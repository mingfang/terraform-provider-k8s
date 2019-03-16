package main

import (
	"bytes"
	"fmt"
	"strconv"
	"strings"

	"github.com/mingfang/terraform-provider-k8s/k8s"
	"k8s.io/kube-openapi/pkg/util/proto"
)

const indentString = "  "

type K8S2TFPrintVisitor struct {
	context interface{}
	key     string
	path    string
	level   int
	indent  string
	isArray bool
	buf     *bytes.Buffer
}

func NewK8S2TFPrintVisitor(buf *bytes.Buffer, key string, path string, context interface{}, level int, isArray bool) *K8S2TFPrintVisitor {
	return &K8S2TFPrintVisitor{
		buf:     buf,
		context: context,
		key:     key,
		path:    path,
		level:   level,
		indent:  strings.Repeat(indentString, level),
		isArray: isArray,
	}
}

func (this *K8S2TFPrintVisitor) VisitArray(array *proto.Array) {
	//log.Println("VisitArray path:", this.path)
	if _, isKind := array.SubType.(*proto.Ref); isKind {
		for _, value := range this.context.([]interface{}) {
			fmt.Fprintln(this.buf)
			visitor := NewK8S2TFPrintVisitor(this.buf, this.key, this.path, value, this.level, false)
			array.SubType.Accept(visitor)
		}
	} else {
		fmt.Fprintf(this.buf, "%s%s = [", this.indent, this.key)
		for _, value := range this.context.([]interface{}) {
			fmt.Fprintf(this.buf, "\n%s%s", this.indent, indentString)
			visitor := NewK8S2TFPrintVisitor(this.buf, this.key, this.path, value, this.level+1, true)
			array.SubType.Accept(visitor)
			fmt.Fprint(this.buf, ",")
		}
		fmt.Fprintf(this.buf, "\n%s]", this.indent)
	}
}

func (this *K8S2TFPrintVisitor) VisitMap(proto *proto.Map) {
	//log.Println("VisitMap path:", this.path)
	if this.context == nil {
		return
	}
	fmt.Fprintf(this.buf, "%s%s = {", this.indent, this.key)
	for key := range this.context.(map[string]interface{}) {
		path := this.path + "." + k8s.ToSnake(key)
		//log.Println("VisitMap path:", path)
		if k8s.IsSkipPath(path) || IsSkipPrintPath(path) {
			continue
		}
		if value, ok := this.context.(map[string]interface{})[key]; ok {
			fmt.Fprintln(this.buf)
			visitor := NewK8S2TFPrintVisitor(this.buf, strconv.Quote(key), this.path, value, this.level+1, false)
			proto.SubType.Accept(visitor)
		}
	}
	fmt.Fprintf(this.buf, "\n%s}", this.indent)
}

func (this *K8S2TFPrintVisitor) VisitPrimitive(proto *proto.Primitive) {
	//log.Println("VisitPrimitive GetPath:", proto.GetPath())
	if this.context == nil {
		return
	}
	if !this.isArray {
		fmt.Fprintf(this.buf, "%s%s = ", this.indent, this.key)
	}
	if proto.Format == "int-or-string" {
		switch this.context.(type) {
		case int:
			fmt.Fprintf(this.buf, "%v", strconv.Quote(strconv.Itoa(this.context.(int))))
		case int64:
			fmt.Fprintf(this.buf, "%v", strconv.Quote(strconv.FormatInt(this.context.(int64), 10)))
		case float64:
			fmt.Fprintf(this.buf, "%v", strconv.Quote(strconv.FormatFloat(this.context.(float64), 'f', -1, 64)))
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
		return
	}
	fmt.Fprintf(this.buf, "%s%s {", this.indent, this.key)
	for _, key := range proto.Keys() {
		path := this.path + "." + k8s.ToSnake(key)
		if k8s.IsSkipPath(path) || IsSkipPrintPath(path) {
			continue
		}
		if value, ok := this.context.(map[string]interface{})[key]; ok {
			if value == nil {
				continue
			}
			fmt.Fprintln(this.buf)
			visitor := NewK8S2TFPrintVisitor(this.buf, k8s.ToSnake(key), path, value, this.level+1, false)
			field := proto.Fields[key]
			field.Accept(visitor)
		}
	}
	fmt.Fprintf(this.buf, "\n%s}", this.indent)
}

func (this *K8S2TFPrintVisitor) VisitReference(proto proto.Reference) {
	//log.Println("VisitReference GetPath:", proto.GetPath())
	proto.SubSchema().Accept(this)
}
