package k8s

import (
	"fmt"
	"log"
	"strconv"

	tfSchema "github.com/hashicorp/terraform/helper/schema"
	"github.com/hashicorp/terraform/helper/structure"

	"k8s.io/kube-openapi/pkg/util/proto"
)

type TF2K8SVisitor struct {
	Object       interface{}
	context      interface{}
	resourceData *tfSchema.ResourceData
	keyPath      string
	jsonPath     string
	ops          []PatchOperation
}

func NewTF2K8SVisitor(resourceData *tfSchema.ResourceData, keyPath string, jsonPath string, context interface{}) *TF2K8SVisitor {
	return &TF2K8SVisitor{
		resourceData: resourceData,
		keyPath:      keyPath,
		jsonPath:     jsonPath,
		context:      context,
		ops:          make([]PatchOperation, 0, 0),
	}
}

func (this *TF2K8SVisitor) VisitArray(proto *proto.Array) {
	//log.Println("VisitArray keyPath:", this.keyPath)
	var oldLen int
	var newLen int
	if this.resourceData.HasChange(this.keyPath) {
		oldV, newV := this.resourceData.GetChange(this.keyPath)
		oldLen = len(oldV.([]interface{}))
		newLen = len(newV.([]interface{}))
		//log.Println("VisitArray HasChange:", this.keyPath, "old:", oldV, "new:", newV, "oldLen:", oldLen, "newLen:", newLen)

		//is deleted
		if newLen == 0 {
			this.ops = append(this.ops, &RemoveOperation{
				Path: this.jsonPath,
			})
			return
		}

		//resize to smaller
		//note in jsonpatch, removing shifts all elements so removing same index(newLen) actually removes different elements
		for i := newLen; i < oldLen; i++ {
			this.ops = append(this.ops, &RemoveOperation{
				Path: this.jsonPath + "/" + strconv.Itoa(newLen),
			})
		}
	}

	this.Object = make([]interface{}, len(this.context.([]interface{})))
	for i := range this.context.([]interface{}) {
		keyPath := this.keyPath + "." + strconv.Itoa(i)
		jsonPath := this.jsonPath + "/" + strconv.Itoa(i)
		//log.Println("VisitArray keyPath:", keyPath)
		if resourceValue, ok := this.resourceData.GetOk(keyPath); ok {
			visitor := NewTF2K8SVisitor(this.resourceData, keyPath, jsonPath, resourceValue)
			proto.SubType.Accept(visitor)
			if visitor.Object != nil {
				this.Object.([]interface{})[i] = visitor.Object
				//log.Println("VisitArray keyPath:", keyPath, " Object:", visitor.Object)

				/*update element*/
				if this.resourceData.HasChange(keyPath) {
					if i < oldLen {
						//replace
						this.ops = append(this.ops, &ReplaceOperation{
							Path:  jsonPath,
							Value: visitor.Object,
						})
					} else {
						//add
						this.ops = append(this.ops, &AddOperation{
							Path:  jsonPath,
							Value: visitor.Object,
						})
					}
				}
			}
		}
	}
	//log.Println("VisitArray keyPath:", this.keyPath, "ops", this.ops)
}

func (this *TF2K8SVisitor) VisitMap(proto *proto.Map) {
	//log.Println("VisitMap keyPath:", this.keyPath)
	if value, exists := this.resourceData.GetOk(this.keyPath); exists {
		this.Object = value
	}
}

func (this *TF2K8SVisitor) VisitPrimitive(proto *proto.Primitive) {
	//log.Println("VisitPrimitive keyPath:", this.keyPath, "Type:", proto.Type, "Format:", proto.Format)
	switch proto.Type {
	case "string":
		if proto.Format == "int-or-string" {
			if asInt, err := strconv.Atoi(this.context.(string)); err == nil {
				this.Object = asInt
			} else {
				this.Object = this.context
			}
		}else{
			this.Object = this.context
		}
	case "boolean":
		if value, err := strconv.ParseBool(this.context.(string)); err == nil {
			this.Object = value
		}
	default:
		this.Object = this.context
	}
}

func (this *TF2K8SVisitor) VisitKind(proto *proto.Kind) {
	//log.Println("VisitKind keyPath:", this.keyPath)

	//special handling for JSON data
	if proto.GetPath().String() == "io.k8s.apiextensions-apiserver.pkg.apis.apiextensions.v1beta1.JSONSchemaProps" {
		this.handleJSON()
		return
	}

	this.Object = map[string]interface{}{}
	for _, key := range proto.Keys() {
		var keyPath, jsonPath string
		if this.keyPath == "" {
			keyPath = ToSnake(key)
			jsonPath = "/" + key
		} else {
			switch this.context.(type) {
			case []interface{}:
				keyPath = this.keyPath + ".0." + ToSnake(key)
				jsonPath = this.jsonPath + "/" + key
			case map[string]interface{}:
				keyPath = this.keyPath + "." + ToSnake(key)
				jsonPath = this.jsonPath + "/" + key
			}
		}
		if IsSkipPath(keyPath) {
			continue
		}
		/*
		valueGet := this.resourceData.Get(keyPath)
		valueGetOk, ok := this.resourceData.GetOk(keyPath)
		valueGetOkExists, exists := this.resourceData.GetOkExists(keyPath)
		switch valueGet.(type) {
		case []interface{}:
		case map[string]interface{}:
		default:
			log.Println("VisitKind keyPath:", keyPath, "HasChange:", this.resourceData.HasChange(keyPath), "Get:", valueGet, "GetOK:", valueGetOk, ok, "GetOkExists:", valueGetOkExists, exists)
		}
		*/
		if value, ok := this.resourceData.GetOk(keyPath); ok {
			visitor := NewTF2K8SVisitor(this.resourceData, keyPath, jsonPath, value)
			v := proto.Fields[key]
			v.Accept(visitor)
			if visitor.Object != nil {
				//filter out empty blocks when creating
				switch visitor.Object.(type) {
				case []interface{}:
					if len(visitor.Object.([]interface{})) > 0 {
						this.Object.(map[string]interface{})[key] = visitor.Object
					}
				case map[string]interface{}:
					if len(visitor.Object.(map[string]interface{})) > 0 {
						this.Object.(map[string]interface{})[key] = visitor.Object
					}
				default:
					this.Object.(map[string]interface{})[key] = visitor.Object
				}
			}

			/* for update only */
			if this.resourceData.HasChange(keyPath) {
				if len(visitor.ops) > 0 {
					this.ops = append(this.ops, visitor.ops...)
				} else {
					this.ops = append(this.ops, &AddOperation{
						Path:  jsonPath,
						Value: visitor.Object,
					})
				}
			}
			//log.Println("VisitKind keyPath:", keyPath, " Object:", visitor.Object, "ops:", visitor.ops)
		}
	}
	//log.Println("VisitKind keyPath:", this.keyPath, "ops:", this.ops)
}

func (this *TF2K8SVisitor) VisitReference(proto proto.Reference) {
	proto.SubSchema().Accept(this)
}

//same as VisitPrimitive for string type
func (this *TF2K8SVisitor) VisitArbitrary(proto *proto.Arbitrary) {
	//log.Println("VisitArbitrary path:", this.keyPath)
	this.handleJSON()
}

func (this *TF2K8SVisitor) handleJSON() {
	//log.Println("handleJSON path:", this.keyPath)
	jsonObject, err := structure.ExpandJsonFromString(fmt.Sprintf("%s", this.context))
	if err != nil {
		log.Fatal(err)
	}
	this.Object = jsonObject
}
