package k8s

import (
	"strconv"

	tfSchema "github.com/hashicorp/terraform/helper/schema"

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
		//todo: resize smaller seems to be buggy
		for i := newLen; i < oldLen; i++ {
			this.ops = append(this.ops, &RemoveOperation{
				Path: this.jsonPath + "/" + strconv.Itoa(newLen-1),
			})
		}
	}

	this.Object = make([]interface{}, len(this.context.([]interface{})))
	for i := range this.context.([]interface{}) {
		keyPath := this.keyPath + "." + strconv.Itoa(i)
		jsonPath := this.jsonPath + "/" + strconv.Itoa(i)
		//log.Println("VisitArray keyPath:", keyPath)
		if this.resourceData.HasChange(keyPath) {
			//oldV, newV := this.resourceData.GetChange(keyPath)
			//log.Println("VisitArray HasChange:", keyPath, "old:", oldV, "new:", newV)
		} else {
			continue
		}
		if resourceValue, exists := this.resourceData.GetOkExists(keyPath); exists {
			visitor := NewTF2K8SVisitor(this.resourceData, keyPath, jsonPath, resourceValue)
			proto.SubType.Accept(visitor)
			if visitor.Object != nil {
				this.Object.([]interface{})[i] = visitor.Object
				//log.Println("VisitArray keyPath:", keyPath, " Object:", visitor.Object)
				if i >= oldLen {
					//add the entire sub-object
					this.ops = append(this.ops, &AddOperation{
						Path:  jsonPath,
						Value: visitor.Object,
					})
				} else {
					//update sub-object fields
					for _, op := range visitor.ops {
						this.ops = append(this.ops, op)
					}
				}
			}
		}
	}
}

func (this *TF2K8SVisitor) VisitMap(proto *proto.Map) {
	//log.Println("VisitMap keyPath:", this.keyPath)
	if this.resourceData.HasChange(this.keyPath) {
		_, newValue := this.resourceData.GetChange(this.keyPath)
		//log.Println("VisitMap HasChange:", this.keyPath, "old:", oldV, "new:", newValue)
		if len(newValue.(map[string]interface{})) == 0 {
			//deleted
			this.ops = append(this.ops, &RemoveOperation{
				Path: this.jsonPath,
			})
		} else {
			//add or update
			this.Object = newValue
			this.ops = append(this.ops, &AddOperation{
				Path:  this.jsonPath,
				Value: this.Object,
			})
		}
	}
}

func (this *TF2K8SVisitor) VisitPrimitive(proto *proto.Primitive) {
	//log.Println("VisitPrimitive", proto)
	//log.Println("VisitPrimitive keyPath:", this.keyPath, "Type:", proto.Type, "Format:", proto.Format)
	if proto.Type == "string" && proto.Format == "int-or-string" {
		if asInt, err := strconv.Atoi(this.context.(string)); err == nil {
			this.Object = asInt
			//log.Println("asInt:", asInt)
		} else {
			this.Object = this.context
			//log.Println("Not asInt:", this.context, "err:", err)
		}
	} else {
		this.Object = this.context
	}
	this.ops = append(this.ops, &AddOperation{
		Path:  this.jsonPath,
		Value: this.Object,
	})

}

func (this *TF2K8SVisitor) VisitKind(proto *proto.Kind) {
	//log.Println("VisitKind keyPath:", this.keyPath)

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
		var oldV interface{}
		if this.resourceData.HasChange(keyPath) {
			oldV, _ = this.resourceData.GetChange(keyPath)
		} else {
			continue
		}

		if value, exists := this.resourceData.GetOkExists(keyPath); exists {
			visitor := NewTF2K8SVisitor(this.resourceData, keyPath, jsonPath, value)
			v := proto.Fields[key]
			v.Accept(visitor)
			if visitor.Object != nil {
				this.Object.(map[string]interface{})[key] = visitor.Object
				//log.Println("VisitKind keyPath:", keyPath, " Object:", visitor.Object)
			}

			var add = oldV == nil
			switch oldV.(type) {
			case []interface{}:
				add = (len(oldV.([]interface{})) == 0) || (oldV.([]interface{})[0] == nil)
			case map[string]interface{}:
				add = len(oldV.(map[string]interface{})) == 0
			}
			if add {
				//add the entire sub-object
				this.ops = append(this.ops, &AddOperation{
					Path:  jsonPath,
					Value: visitor.Object,
				})
			} else {
				//if len(visitor.ops) > 0 {
				//	log.Println("VisitKind keyPath:", keyPath, " update:", visitor.Object, "oldV:", oldV)
				//}
				//update sub-object fields
				for _, op := range visitor.ops {
					this.ops = append(this.ops, op)
				}
			}
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
	this.Object = this.context
	this.ops = append(this.ops, &AddOperation{
		Path:  this.jsonPath,
		Value: this.Object,
	})
}
