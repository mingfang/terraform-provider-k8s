package k8s

import (
	"log"

	tfSchema "github.com/hashicorp/terraform-plugin-sdk/helper/schema"
	"github.com/hashicorp/terraform-plugin-sdk/helper/structure"

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
		this.Schema.Type = tfSchema.TypeString
	default:
		log.Fatal("Invalid proto.Type:", proto.Type)
	}
	this.Schema.Description = proto.GetDescription()
}

func (this *K8S2TFSchemaVisitor) VisitKind(proto *proto.Kind) {
	//log.Println("VisitKind path:", this.path, "GetPath:", proto.GetPath())

	//special handling for JSON data
	if IsJSONSchemaProps(proto.GetPath().String()) {
		this.handleJSON()
		this.Schema.Description = proto.GetDescription()
		return
	}

	elements := map[string]*tfSchema.Schema{}
	for _, key := range proto.Keys() {
		v := proto.Fields[key]
		path := this.path + "." + ToSnake(key)
		//log.Println("VisitKind path:", path)
		if IsSkipPath(path) {
			continue
		}
		schemaVisitor := NewK8S2TFSchemaVisitor(path)
		v.Accept(schemaVisitor)
		if schemaVisitor.Schema.Type == tfSchema.TypeInvalid {
			//log.Println("VisitKind path:", path, "Skipping TypeInvalid")
			continue
		}

		if proto.IsRequired(key) {
			schemaVisitor.Schema.Required = true
			schemaVisitor.Schema.Computed = false
			schemaVisitor.Schema.Optional = false
			schemaVisitor.Schema.ForceNew = IsForceNewField(path)
			schemaVisitor.Schema.Sensitive = IsSensitive(path)
		} else {
			schemaVisitor.Schema.Required = false
			schemaVisitor.Schema.Computed = true
			schemaVisitor.Schema.Optional = true
			schemaVisitor.Schema.ForceNew = IsForceNewField(path)
			schemaVisitor.Schema.Sensitive = IsSensitive(path)
		}

		elements[ToSnake(key)] = &schemaVisitor.Schema
	}

	this.Schema.Type = tfSchema.TypeList
	this.Schema.Description = proto.GetDescription()
	this.Schema.Elem = &tfSchema.Resource{Schema: elements}
	this.Schema.MaxItems = 1
}

//loop detection, https://github.com/kubernetes/kubernetes/pull/70428/files
var visitedReferences = map[string]struct{}{}

func (this *K8S2TFSchemaVisitor) VisitReference(r proto.Reference) {
	//log.Println("VisitReference path:", this.path)
	if _, ok := visitedReferences[r.Reference()]; ok {
		//if loop then treat it as json
		this.handleJSON()
		this.Schema.Description = r.GetDescription()
		return
	}

	visitedReferences[r.Reference()] = struct{}{}
	r.SubSchema().Accept(this)
	delete(visitedReferences, r.Reference())

	this.Schema.Description = r.GetDescription()
}

func (this *K8S2TFSchemaVisitor) VisitArbitrary(proto *proto.Arbitrary) {
	//log.Println("VisitArbitrary path:", this.path)
	this.handleJSON()
	this.Schema.Description = proto.GetDescription()
}

func (this *K8S2TFSchemaVisitor) handleJSON() {
	//log.Println("handleJSON path:", this.path)
	this.Schema.Type = tfSchema.TypeString
	this.Schema.StateFunc = func(v interface{}) string {
		json, _ := structure.NormalizeJsonString(v.(string))
		return json
	}
	this.Schema.DiffSuppressFunc = structure.SuppressJsonDiff
}
