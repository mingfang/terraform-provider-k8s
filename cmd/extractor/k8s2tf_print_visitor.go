package main

import (
	"bytes"
	"fmt"
	//"log"
	"strconv"
	"strings"

	"github.com/mingfang/terraform-provider-k8s/k8s"
	"k8s.io/kube-openapi/pkg/util/proto"
)

const indentString = "  "

type K8S2TFPrintVisitor struct {
	context interface{}
	path    string
	level   int
	indent  string
	isArray bool
	buf     *bytes.Buffer
}

func NewK8S2TFPrintVisitor(buf *bytes.Buffer, path string, context interface{}, level int, isArray bool) *K8S2TFPrintVisitor {
	return &K8S2TFPrintVisitor{
		buf:     buf,
		context: context,
		path:    path,
		level:   level,
		indent:  strings.Repeat(indentString, level),
		isArray: isArray,
	}
}

func (this *K8S2TFPrintVisitor) VisitArray(proto *proto.Array) {
	//log.Println("VisitArray path:", this.path)
	fmt.Fprintf(this.buf, "= [")
	for _, value := range this.context.([]interface{}) {
		fmt.Fprintf(this.buf, "\n%s", this.indent)
		visitor := NewK8S2TFPrintVisitor(this.buf, this.path, value, this.level+1, true)
		proto.SubType.Accept(visitor)
		fmt.Fprint(this.buf, ",")
	}
	fmt.Fprintf(this.buf, "\n%s]", strings.Repeat(indentString, this.level-1))
}

func (this *K8S2TFPrintVisitor) VisitMap(proto *proto.Map) {
	//log.Println("VisitMap path:", this.path)
	if this.context == nil {
		return
	}
	fmt.Fprint(this.buf, "{")
	for key := range this.context.(map[string]interface{}) {
		path := this.path + "." + k8s.ToSnake(key)
		//log.Println("VisitMap path:", path)
		if k8s.IsSkipPath(path) || IsSkipPrintPath(path) {
			continue
		}
		if value, ok := this.context.(map[string]interface{})[key]; ok {
			fmt.Fprintf(this.buf, "\n%s%s ", this.indent, strconv.Quote(key))
			visitor := NewK8S2TFPrintVisitor(this.buf, this.path, value, this.level+1, false)
			proto.SubType.Accept(visitor)
		}
	}
	fmt.Fprintf(this.buf, "\n%s}", strings.Repeat(indentString, this.level-1))
}

func (this *K8S2TFPrintVisitor) VisitPrimitive(proto *proto.Primitive) {
	//log.Println("VisitPrimitive GetPath:", proto.GetPath())
	if this.context == nil {
		return
	}
	if !this.isArray {
		fmt.Fprintf(this.buf, "= ")
	}
	if proto.Format == "int-or-string" {
		switch this.context.(type) {
		case int:
			fmt.Fprintf(this.buf, "%v", strconv.Quote(strconv.Itoa(this.context.(int))))
		case int64:
			fmt.Fprintf(this.buf, "%v", strconv.Quote(strconv.FormatInt(this.context.(int64), 10)))
		case float64:
			fmt.Fprintf(this.buf, "%v", strconv.Quote(strconv.FormatFloat(this.context.(float64), '-f', '-1, 64)))
		default:
			fmt.Fprintf(this.buf, "%v", strconv.Quote(this.context.(string)))
		}
	} else {
		if proto.Type == "string" {
			//escape ${
			fmt.Fprintf(this.buf, "%v", strconv.Quote(strings.Replace(this.context.(string), "${", "$${", -1)))
		} else {
			fmt.Fprintf(this.buf, "%v", this.context)
		}
	}
}

func (this *K8S2TFPrintVisitor) VisitKind(proto *proto.Kind) {
	//log.Println("VisitKind path:", this.path, "GetPath:", proto.GetPath())
	if this.context == nil {
		//log.Println("VisitKind GetPath:", proto.GetPath(), "context is nil")
		return
	}
	fmt.Fprint(this.buf, "{")
	for _, key := range proto.Keys() {
		//log.Println("VisitKind GetPath:", proto.GetPath(), "Key:", key)
		path := this.path + "." + k8s.ToSnake(key)
		//log.Println("VisitKind path:", path)
		if k8s.IsSkipPath(path) || IsSkipPrintPath(path){
			continue
		}
		if value, ok := this.context.(map[string]interface{})[key]; ok {
			if value == nil {
				continue
			}
			fmt.Fprintf(this.buf, "\n%s%s ", this.indent, k8s.ToSnake(key))
			visitor := NewK8S2TFPrintVisitor(this.buf, path, value, this.level+1, false)
			field := proto.Fields[key]
			field.Accept(visitor)
		}
	}
	if this.level == 0 {
		fmt.Fprintf(this.buf, "\n}\n")
	} else {
		fmt.Fprintf(this.buf, "\n%s}", strings.Repeat(indentString, this.level-1))
	}
}

func (this *K8S2TFPrintVisitor) VisitReference(proto proto.Reference) {
	//log.Println("VisitReference GetPath:", proto.GetPath())
	proto.SubSchema().Accept(this)
}
