package k8s

import (
	"encoding/json"
	"fmt"
	"log"
	"strconv"

	"k8s.io/kube-openapi/pkg/util/proto"
)

type K8S2TFReadVisitor struct {
	Object  interface{}
	context interface{}
	path    string
}

func NewK8S2TFReadVisitor(path string, context interface{}) *K8S2TFReadVisitor {
	return &K8S2TFReadVisitor{
		context: context,
		path:    path,
	}
}

func (this *K8S2TFReadVisitor) VisitArray(proto *proto.Array) {
	//log.Println("VisitArray path:", this.path)
	this.Object = make([]interface{}, len(this.context.([]interface{})))
	for i, v := range this.context.([]interface{}) {
		visitor := NewK8S2TFReadVisitor(this.path, v)
		proto.SubType.Accept(visitor)
		if visitor.Object != nil {
			switch visitor.Object.(type) {
			case []interface{}:
				this.Object.([]interface{})[i] = visitor.Object.([]interface{})[0]
			default:
				this.Object.([]interface{})[i] = visitor.Object
			}
			//log.Println("VisitArray path:", this.path, " Object:", visitor.Object)
		}
	}
	if (len(this.Object.([]interface{})) == 0) || (this.Object.([]interface{})[0] == nil) {
		//log.Println("VisitArray empty path:", this.path)
		this.Object = nil
	}
}

func (this *K8S2TFReadVisitor) VisitMap(proto *proto.Map) {
	//log.Println("VisitMap path:", this.path)
	if this.context == nil {
		return
	}
	this.Object = make(map[string]interface{})
	for key := range this.context.(map[string]interface{}) {
		path := this.path + "." + ToSnake(key)
		//log.Println("VisitMap path:", path)
		if IsSkipPath(path) {
			continue
		}
		if value, ok := this.context.(map[string]interface{})[key]; ok {
			visitor := NewK8S2TFReadVisitor(this.path, value)
			proto.SubType.Accept(visitor)
			if visitor.Object != nil {
				this.Object.(map[string]interface{})[key] = visitor.Object
			}
		}
	}
	if len(this.Object.(map[string]interface{})) == 0 {
		//log.Println("VisitMap empty path:", this.path)
		this.Object = nil
	}
}

func (this *K8S2TFReadVisitor) VisitPrimitive(proto *proto.Primitive) {
	//log.Println("VisitPrimitive GetPath:", proto.GetPath())
	if this.context == nil {
		return
	}
	if proto.Format == "int-or-string" {
		switch this.context.(type) {
		case int:
			this.Object = strconv.Itoa(this.context.(int))
		case int64:
			this.Object = strconv.FormatInt(this.context.(int64), 10)
		default:
			this.Object = this.context
		}
	} else {
		if proto.Type == "string" {
			this.Object = this.context.(string)
		} else {
			this.Object = this.context
		}
	}
}

func (this *K8S2TFReadVisitor) VisitKind(proto *proto.Kind) {
	//log.Println("VisitKind path:", this.path, "GetPath:", proto.GetPath())
	if this.context == nil {
		return
	}

	//special handling for JSON data
	if proto.GetPath().String() == "io.k8s.apiextensions-apiserver.pkg.apis.apiextensions.v1beta1.JSONSchemaProps" {
		this.handleJSON()
		return
	}

	this.Object = make([]interface{}, 1)
	this.Object.([]interface{})[0] = make(map[string]interface{})
	for _, key := range proto.Keys() {
		//log.Println("VisitKind GetPath:", proto.GetPath(), "Key:", key)
		snakeKey := ToSnake(key)
		keyPath := this.path + "." + snakeKey
		//log.Println("K8S2TFReadVisitor VisitKind keyPath:", keyPath)
		if IsSkipPath(keyPath) {
			continue
		}
		if value, ok := this.context.(map[string]interface{})[key]; ok {
			visitor := NewK8S2TFReadVisitor(keyPath, value)
			field := proto.Fields[key]
			field.Accept(visitor)
			if visitor.Object != nil {
				this.Object.([]interface{})[0].(map[string]interface{})[snakeKey] = visitor.Object
			}
		}
	}
}

func (this *K8S2TFReadVisitor) VisitReference(proto proto.Reference) {
	//log.Println("VisitReference GetPath:", proto.GetPath())
	proto.SubSchema().Accept(this)
}

func (this *K8S2TFReadVisitor) VisitArbitrary(proto *proto.Arbitrary) {
	//log.Println("VisitArbitrary GetPath:", proto.GetPath())
	this.handleJSON()
}

func (this *K8S2TFReadVisitor) handleJSON() {
	//log.Println("handleJSON path:", this.path)
	if this.context == nil {
		return
	}
	jsonBytes, err := json.Marshal(this.context)
	if err != nil {
		log.Fatal(err)
		return
	}
	this.Object = fmt.Sprintf("%s", jsonBytes)
}
