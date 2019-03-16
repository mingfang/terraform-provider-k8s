package main

import (
	"errors"
	"fmt"
	"os"
	"sort"
	"strings"
	"text/template"

	tfSchema "github.com/hashicorp/terraform/helper/schema"
	"github.com/mingfang/terraform-provider-k8s/k8s"
)

func main() {
	argsWithoutProg := os.Args[1:]
	if len(argsWithoutProg) < 1 {
		mainPrintList()
	} else {
		resource := argsWithoutProg[0]
		var count = ""
		if len(argsWithoutProg) > 1 {
			count = argsWithoutProg[1]
		}
		var lifecycle = ""
		if len(argsWithoutProg) > 2 {
			lifecycle = argsWithoutProg[2]
		}
		mainPrintResource(resource, count, lifecycle)
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

type ResourceData struct {
	ResourceKey string
	Count       string
	Lifecycle   string
	Resource    *tfSchema.Resource
}

var resourceTemplate = `
{{ define "main" -}}
//GENERATE//{{ .ResourceKey }}//{{ .Count }}//{{ .Lifecycle }}
resource "{{ .ResourceKey }}" "this" {
  {{ .Count }}

  {{- $parameters := (printf "local.%v_parameters" .ResourceKey) }}
  {{- range $name, $schema := .Resource.Schema }}
    {{- with subResource $schema }}
      {{- if (isStatic $name) }}
        {{ template "static" dict "Name" $name "Schema" $schema "Resource" . "Parent" $parameters }}
      {{- else }}
        {{ template "dynamic" dict "Name" $name "Schema" $schema "Resource" . "Parent" $parameters }}
      {{- end }}
    {{- else }}
      {{ template "schema" dict "Name" $name "Schema" $schema "Parent" $parameters }}
    {{- end }}
  {{- end }}

  lifecycle {
    {{ .Lifecycle }}
  }
}
{{- end }}

{{ define "static" }}
  {{ .Name }} {
    {{- $parent := .Parent }} 
    {{- range $name, $schema := .Resource.Schema }}
      {{- if not (isReadOnly $schema) }}
        {{- with subResource $schema }}
          {{- if (isStatic $name) }}
            {{ template "static" dict "Name" $name "Schema" $schema "Resource" . "Parent" $parent }}
          {{- else }}
            {{ template "dynamic" dict "Name" $name "Schema" $schema "Resource" . "Parent" $parent }}
          {{- end }}
        {{- else -}}
          {{ template "schema" dict "Name" $name "Schema" $schema "Parent" $parent }}
        {{- end }}
      {{- end }}
    {{- end }}
  }
{{- end }}

{{ define "dynamic" }}
  dynamic "{{ .Name }}" {
    {{- $parent := .Parent }}
    {{- $newParent := printf "%v%v" .Name ".value" }}
    for_each = {{ if eq .Schema.MaxItems 1 -}}
                 lookup({{ $parent }}, "{{ .Name }}", null) == null ? [] : [{{ $parent }}.{{ .Name }}]
               {{- else -}}
                 lookup({{ $parent }}, "{{ .Name }}", [])
               {{- end }}
    content {
      {{- range $name, $schema := .Resource.Schema }}
        {{- if not (isReadOnly $schema) }}
          {{- with subResource $schema }}
            {{- if (isStatic $name) }}
              {{ template "static" dict "Name" $name "Schema" $schema "Resource" . "Parent" $newParent }}
            {{- else -}}
              {{ template "dynamic" dict "Name" $name "Schema" $schema "Resource" . "Parent" $newParent }}
            {{- end }}
          {{- else -}}
            {{ template "schema" dict "Name" $name "Schema" $schema "Parent" $newParent }}
          {{- end }}
        {{- end }}
      {{- end }}
    }
  }
{{- end }}

{{ define "schema" }}
  {{- if .Schema.Required }}
      {{ .Name }} = {{ .Parent }}.{{ .Name }}
  {{- else }}
	{{- if isList .Schema }}
      {{ .Name }} = contains(keys({{ .Parent }}), "{{ .Name }}") ? {{ .Parent }}.{{ .Name }} : null
    {{- else }}
      {{ .Name }} = lookup({{ .Parent }}, "{{ .Name }}", null)
    {{- end }}
  {{- end }}
{{- end }}
`

func mainPrintResource(resourceKey string, count string, lifecycle string) {
	resourcesMap := k8s.BuildResourcesMap()
	resource := resourcesMap[resourceKey]
	//k8s.Dump(resource)

	t, err := template.New("").Funcs(template.FuncMap{
		"dict": func(values ...interface{}) (map[string]interface{}, error) {
			if len(values)%2 != 0 {
				return nil, errors.New("invalid dict call")
			}
			dict := make(map[string]interface{}, len(values)/2)
			for i := 0; i < len(values); i += 2 {
				key, ok := values[i].(string)
				if !ok {
					return nil, errors.New("dict keys must be strings")
				}
				dict[key] = values[i+1]
			}
			return dict, nil
		},
		"subResource": func(schema *tfSchema.Schema) (resource *tfSchema.Resource) {
			switch schema.Type {
			case tfSchema.TypeList:
				if resource, isResource := schema.Elem.(*tfSchema.Resource); isResource {
					return resource
				} else {
					return nil
				}
			default:
				return nil
			}
		},
		"isReadOnly": func(schema *tfSchema.Schema) bool {
			return strings.Contains(schema.Description, "Read-only")
		},
		"isStatic": func(name string) bool {
			return name == "metadata" || name == "spec" || name == "template"
		},
		"isList": func(schema *tfSchema.Schema) bool {
			switch schema.Type {
			case tfSchema.TypeList:
				return true
			default:
				return false
			}
		},
	}).Parse(resourceTemplate)
	if err != nil {
		panic(err)
	}

	data := ResourceData{
		ResourceKey: resourceKey,
		Count:       count,
		Lifecycle:   lifecycle,
		Resource:    resource,
	}
	err = t.ExecuteTemplate(os.Stdout, "main", data)
	if err != nil {
		panic(err)
	}
}
