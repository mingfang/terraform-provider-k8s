package main

import (
	"fmt"
	"os"
	"strings"
	//"strconv"
	tfSchema "github.com/hashicorp/terraform/helper/schema"
	"github.com/mingfang/terraform-provider-k8s/k8s"
	"sort"
)

const indentString = "  "

func main() {
	argsWithoutProg := os.Args[1:]
	if len(argsWithoutProg) < 1 {
		mainPrintList()
	} else {
		mainPrintResource(argsWithoutProg[0])
	}

}

func mainPrintList() {
	resourcesMap := k8s.BuildResourcesMap()
	keys := make([]string, 0, len(resourcesMap))
	for k := range resourcesMap {
		keys = append(keys, k)
	}
	sort.Strings(keys)
	fmt.Println("\nResources\n---------")
	for _, resourceKey := range keys {
		fmt.Println("resource \"" + resourceKey + "\"")
	}

	dataSourcesMap := k8s.BuildDataSourcesMap()
	keys = make([]string, 0, len(dataSourcesMap))
	for k := range dataSourcesMap {
		keys = append(keys, k)
	}
	sort.Strings(keys)
	fmt.Println("\nDataSources\n-----------")
	for _, resourceKey := range keys {
		fmt.Println("data \"" + resourceKey + "\"")
	}
}

func mainPrintResource(resourceKey string) {
	resourcesMap := k8s.BuildResourcesMap()
	resource := resourcesMap[resourceKey]
	fmt.Printf("resource \"%s\" \"name\" {\n", resourceKey)
	printResource(resource, 1)
	fmt.Println("}")
}

func printResource(resource *tfSchema.Resource, level int) {
	//indent := strings.Repeat(fmt.Sprintf("%v%v", level, level), level)
	indent := strings.Repeat(indentString, level)
	keys := make([]string, 0, len(resource.Schema))
	for k := range resource.Schema {
		keys = append(keys, k)
	}
	sort.Strings(keys)
	for _, name := range keys {
		schema := resource.Schema[name]
		//fmt.Printf("%s// %s%s%s%s%s\n", indent,
		//	schema.Type,
		//	//whenTrue(schema.Type == tfSchema.TypeList, "[" + strconv.Itoa(schema.MinItems) + "/" + strconv.Itoa(schema.MaxItems) + "]"),
		//	whenTrue(schema.Optional, " Opional"),
		//	whenTrue(schema.Required, " Required"),
		//	whenTrue(schema.Computed, " Computed"),
		//	whenTrue(schema.ForceNew, " ForceNew"),
		//	//schema.Description,
		//)
		fmt.Printf("%s%s%s", indent, name, open(schema, level))

		fmt.Printf("%s", middle(schema, level))

		fmt.Printf("%s", close(schema, level))

	}
}

func open(schema *tfSchema.Schema, level int) string {
	//indent := strings.Repeat(indentString, level)
	switch schema.Type {
	case tfSchema.TypeList:
		if _, isResource := schema.Elem.(*tfSchema.Resource); isResource {
			return " {\n"
		} else {
			return " = [\n"
		}
	case tfSchema.TypeMap:
		return " {\n"
	case tfSchema.TypeString:
		return " = \"\"\n"
	case tfSchema.TypeBool:
		return " = true/false\n"
	case tfSchema.TypeInt:
		return " = 0\n"
	}
	return ""
}

func middle(schema *tfSchema.Schema, level int) string {
	indent := strings.Repeat(indentString, level)
	switch schema.Type {
	case tfSchema.TypeList:
		if resource, isResource := schema.Elem.(*tfSchema.Resource); isResource {
			printResource(resource, level+1)
		} else {
			return fmt.Sprintf("%s%s\"\"\n", indent, indentString)
		}
	case tfSchema.TypeMap:
		return fmt.Sprintf("%s%skey = \"\"\n", indent, indentString)
	default:
		return ""
	}
	return ""
}

func close(schema *tfSchema.Schema, level int) string {
	indent := strings.Repeat(indentString, level)
	switch schema.Type {
	case tfSchema.TypeList:
		if _, isResource := schema.Elem.(*tfSchema.Resource); isResource {
			return indent + "}\n"
		} else {
			return indent + "]\n"
		}
	case tfSchema.TypeMap:
		return indent + "}\n"
	default:
		return ""
	}
	return ""
}

func whenTrue(condition bool, value string) string {
	if condition {
		return value
	} else {
		return ""
	}
}
