package k8s

import (
	"log"
	"strings"

	tfSchema "github.com/hashicorp/terraform/helper/schema"

	"k8s.io/kube-openapi/pkg/util/proto"
)

type K8S2TFSchemaVisitor struct {
	Schema   tfSchema.Schema
	readOnly bool
	path     string
}

func NewK8S2TFSchemaVisitor(path string) *K8S2TFSchemaVisitor {
	return &K8S2TFSchemaVisitor{
		Schema: tfSchema.Schema{},
		path:   path,
	}
}

func (this *K8S2TFSchemaVisitor) VisitArray(proto *proto.Array) {
	//log.Println("VisitArray path:", this.path)
	schemaVisitor := NewK8S2TFSchemaVisitor(this.path)
	proto.SubType.Accept(schemaVisitor)

	this.Schema.Type = tfSchema.TypeList
	this.Schema.Description = proto.GetDescription()
	if schemaVisitor.Schema.Elem == nil {
		this.Schema.Elem = &schemaVisitor.Schema
	} else {
		this.Schema.Elem = schemaVisitor.Schema.Elem
	}
	this.readOnly = strings.Contains(proto.GetDescription(), "Read-only")
}

func (this *K8S2TFSchemaVisitor) VisitMap(proto *proto.Map) {
	//log.Println("VisitMap path:", this.path)
	schemaVisitor := NewK8S2TFSchemaVisitor(this.path)
	proto.SubType.Accept(schemaVisitor)

	this.Schema.Type = tfSchema.TypeMap
	this.Schema.Description = proto.GetDescription()
	if schemaVisitor.Schema.Elem == nil {
		this.Schema.Elem = &schemaVisitor.Schema
	} else {
		this.Schema.Elem = schemaVisitor.Schema.Elem
	}
	this.readOnly = strings.Contains(proto.GetDescription(), "Read-only")
}

func (this *K8S2TFSchemaVisitor) VisitPrimitive(proto *proto.Primitive) {
	switch proto.Type {
	case "integer":
		this.Schema.Type = tfSchema.TypeInt
	case "number":
		this.Schema.Type = tfSchema.TypeFloat
	case "string":
		this.Schema.Type = tfSchema.TypeString
	case "boolean":
		this.Schema.Type = tfSchema.TypeBool
	default:
		log.Fatal("Invalid proto.Type:", proto.Type)
	}
	this.Schema.Description = proto.GetDescription()
	this.readOnly = strings.Contains(proto.GetDescription(), "Read-only")
}

func (this *K8S2TFSchemaVisitor) VisitKind(proto *proto.Kind) {
	//log.Println("VisitKind path:", this.path, "GetPath:", proto.GetPath())
	elements := map[string]*tfSchema.Schema{}
	for _, key := range proto.Keys() {
		v := proto.Fields[key]
		path := this.path + "." + ToSnake(key)
		//log.Println("VisitKind path:", path)
		if IsSkipPath(path) {
			continue
		}
		schemaVistor := NewK8S2TFSchemaVisitor(path)
		v.Accept(schemaVistor)

		if proto.IsRequired(key) {
			schemaVistor.Schema.Required = true
			schemaVistor.Schema.Computed = false
			schemaVistor.Schema.Optional = false
			schemaVistor.Schema.ForceNew = IsForceNewField(path)
		} else {
			schemaVistor.Schema.Required = false
			schemaVistor.Schema.Computed = (schemaVistor.Schema.Type != tfSchema.TypeMap) && (schemaVistor.Schema.Type != tfSchema.TypeList) || IsComputedField(path)
			schemaVistor.Schema.Optional = true
			schemaVistor.Schema.ForceNew = IsForceNewField(path)
		}

		elements[ToSnake(key)] = &schemaVistor.Schema
	}

	this.Schema.Type = tfSchema.TypeList
	this.Schema.Description = proto.GetDescription()
	this.Schema.Elem = &tfSchema.Resource{Schema: elements}
	this.Schema.MaxItems = 1
	this.readOnly = strings.Contains(proto.GetDescription(), "Read-only")
}

func (this *K8S2TFSchemaVisitor) VisitReference(proto proto.Reference) {
	proto.SubSchema().Accept(this)
	this.Schema.Description = proto.GetDescription()
	this.readOnly = strings.Contains(proto.GetDescription(), "Read-only")
}
