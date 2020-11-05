package main

import (
	"bytes"
	"encoding/json"
	"fmt"
	"log"
	"sort"
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
	//fmt.Fprintf(this.buf, "%s//VisitMap path: %s\n", this.indent, proto.GetPath())
	fmt.Fprintf(this.buf, "%s%s = {", this.indent, this.key)
	keys := make([]string, 0, len(this.context.(map[string]interface{})))
	for k := range this.context.(map[string]interface{}) {
		keys = append(keys, k)
	}
	sort.Strings(keys)
	for _, key := range keys {
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
	//log.Println("VisitPrimitive", "path:", this.path, "GetPath:", proto.GetPath())
	if this.context == nil {
		return
	}
	if !this.isArray {
		fmt.Fprintf(this.buf, "%s%s = ", this.indent, this.key)
	}
	if proto.Format == "int-or-string" {
		switch this.context.(type) {
		case int:
			fmt.Fprintf(this.buf, "%s", strconv.Quote(strconv.Itoa(this.context.(int))))
		case int64:
			fmt.Fprintf(this.buf, "%s", strconv.Quote(strconv.FormatInt(this.context.(int64), 10)))
		case float64:
			fmt.Fprintf(this.buf, "%s", strconv.Quote(strconv.FormatFloat(this.context.(float64), 'f', -1, 64)))
		default:
			fmt.Fprintf(this.buf, "%s", strconv.Quote(strings.Replace(this.context.(string), "${", "$${", -1)))
		}
	} else {
		if proto.Type == "string" {
			//escape ${
			value := fmt.Sprintf("%s", this.context)
			value = strings.Replace(value, "${", "$${", -1)
			value = strings.Replace(value, "%{", "%%{", -1)
			if strings.Contains(value, "\n") || strings.Contains(value, "\"") {
				if this.isArray {
					indent := this.indent
					indentedValue := strings.Replace(value, "\n", "\n"+indent, -1)
					fmt.Fprintf(this.buf, "<<-EOF\n%s%s\n%sEOF\n%s", indent, indentedValue, indent, indent)
				} else {
					indent := this.indent + indentString
					indentedValue := strings.Replace(value, "\n", "\n"+indent, -1)
					fmt.Fprintf(this.buf, "<<-EOF\n%s%s\n%sEOF", indent, indentedValue, indent)
				}
			} else {
				fmt.Fprintf(this.buf, "%s", strconv.Quote(value))
			}
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

	//fmt.Fprintf(this.buf, "%s//VisitKind %s %s\n", this.indent, this.key, proto.GetPath())
	//special handling for JSON data
	if k8s.IsJSONSchemaProps(proto.GetPath().String()) {
		//log.Println("VisitKind JSON:", this.path)
		this.handleJSON()
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

func (this *K8S2TFPrintVisitor) VisitArbitrary(proto *proto.Arbitrary) {
	//log.Println("VisitArbitrary GetPath:", proto.GetPath())
	this.handleJSON()
}

func (this *K8S2TFPrintVisitor) handleJSON() {
	//log.Println("handleJSON path:", this.path)
	if this.context == nil {
		return
	}
	indent := this.indent + indentString
	jsonBytes, err := json.MarshalIndent(this.context, indent, "  ")
	if err != nil {
		log.Fatal(err)
		return
	}
	fmt.Fprintf(this.buf, "%s%s = <<-JSON\n%s%s\n%sJSON", this.indent, this.key, indent, jsonBytes, indent)
}
