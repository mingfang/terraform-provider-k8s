package main

import (
	"bytes"
	"errors"
	"flag"
	"fmt"
	"log"
	"os"
	"os/exec"
	"sort"
	"strings"
	"text/template"

	tfSchema "github.com/hashicorp/terraform/helper/schema"
	"github.com/mingfang/terraform-provider-k8s/k8s"
)

func main() {
	var count, lifecycle string
	var doc, dynamic bool

	flag.StringVar(&count, "count", "", "count expression")
	flag.StringVar(&lifecycle, "lifecycle", "", "lifecycle expression")
	flag.BoolVar(&dynamic, "dynamic", false, "generate dynamic blocks")
	flag.BoolVar(&doc, "doc", false, "generate markdown documentation")
	flag.Parse()

	args := flag.Args()
	if len(args) < 1 {
		mainPrintList()
	} else {
		resource := args[0]
		mainPrintResource(resource, count, lifecycle, dynamic, doc)
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

const resourceTemplateDynamic = `
{{ define "main" }}
{{- execute "resource_dynamic" (dict "ResourceKey" .ResourceKey "Resource" .Resource "Count" "" "Lifecycle" "") | fmt}}
{{ end }}

{{ define "resource_dynamic" -}}
//GENERATE DYNAMIC//{{ .ResourceKey }}//{{ .Count }}//{{ .Lifecycle }}
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
      {{ .Name }} = contains(keys({{ .Parent }}), "{{ .Name }}") ? tolist({{ .Parent }}.{{ .Name }}) : null
    {{- else }}
      {{ .Name }} = lookup({{ .Parent }}, "{{ .Name }}", null)
    {{- end }}
  {{- end }}
{{- end }}
`

const resourceTemplateStatic = `
{{ define "main" }}
{{- execute "resource_static" (dict "ResourceKey" .ResourceKey "Resource" .Resource "Count" "" "Lifecycle" "") | fmt}}
{{ end }}

{{ define "resource_static" -}}
//GENERATE STATIC//{{ .ResourceKey }}//{{ .Count }}//{{ .Lifecycle }}
resource "{{ .ResourceKey }}" "this" {
  {{ .Count }}

  {{- range $name, $schema := .Resource.Schema }}
    {{- with subResource $schema }}
      {{ template "static" dict "Name" $name "Schema" $schema "Resource" . }}
    {{- else }}
      {{ template "schema" dict "Name" $name "Schema" $schema  }}
    {{- end }}
  {{- end }}

  lifecycle {
    {{ .Lifecycle }}
  }
}
{{- end }}

{{ define "static" }}
  {{- if .Schema.Required }}
    // Required
  {{- end }}
  {{ .Name }} {
    {{- range $name, $schema := .Resource.Schema }}
      {{- if not (isReadOnly $schema) }}
        {{- with subResource $schema }}
          {{ template "static" dict "Name" $name "Schema" $schema "Resource" . }}
        {{- else -}}
          {{ template "schema" dict "Name" $name "Schema" $schema }}
        {{- end }}
      {{- end }}
    {{- end }}
  }
{{- end }}

{{ define "schema" }}
  {{- if .Schema.Required }}
    // Required
  {{- end }}
  {{- if isList .Schema }}
    {{ .Name }} = [ "{{ .Schema.Elem.Type }}" ]
  {{- else if isMap .Schema }}
    {{ .Name }} = { "key" = "{{ .Schema.Elem.Type }}" }
  {{- else }}
    {{ .Name }} = "{{ .Schema.Type }}"
  {{- end }}
{{- end }}
`

const docTemplate = `
{{ define "main_doc" }}
# resource "{{ .ResourceKey }}"

  {{- range $name, $schema := .Resource.Schema }}
    {{- with subResource $schema }}
      {{- template "resource_doc_toc" dict "Name" $name "Schema" $schema "Resource" . }}
    {{- end }}
  {{- end }}

<details>
<summary>example</summary><blockquote>

{{ backtick }}hcl
{{ execute "main" (dict "ResourceKey" .ResourceKey "Resource" .Resource "Count" "" "Lifecycle" "")}}
{{ backtick }}

</details>

  {{ range $name, $schema := .Resource.Schema }}
    {{- with subResource $schema }}
      {{- template "resource_doc" dict "Name" $name "Schema" $schema "Resource" . }}
    {{- else }}
      {{- template "schema_doc" dict "Name" $name "Schema" $schema  }}
    {{- end }}
  {{- end }}

{{- end }}

{{ define "resource_doc_toc" }}
<details>
<summary>{{ .Name }}</summary><blockquote>

    {{ range $name, $schema := .Resource.Schema }}
        {{- with subResource $schema }}
        {{- else }}
          {{- template "schema_doc_toc" dict "Name" $name "Schema" $schema }}
        {{- end }}
    {{- end }}

    {{ range $name, $schema := .Resource.Schema }}
        {{- with subResource $schema }}
          {{- template "resource_doc_toc" dict "Name" $name "Schema" $schema "Resource" . }}
        {{- end }}
    {{- end }}
</details>
{{ end }}

{{ define "schema_doc_toc" }}
- [{{ .Name }}](#{{ .Name }}){{ if .Schema.Required }}*{{ end }} 
{{- end }}

{{ define "resource_doc" }}
## {{ .Name }}

{{ .Schema.Description }}

    {{ range $name, $schema := .Resource.Schema }}
        {{- with subResource $schema }}
          {{- template "resource_doc" dict "Name" $name "Schema" $schema "Resource" . }}
        {{- else }}
          {{- template "schema_doc" dict "Name" $name "Schema" $schema }}
        {{- end }}
    {{- end }}
{{- end }}

{{ define "schema_doc" }}
#### {{ .Name }}

###### {{ if .Schema.Required }}Required • {{ end }} {{ if (isReadOnly .Schema) }}ReadOnly • {{ end }}{{ .Schema.Type }}

{{ .Schema.Description }}
{{- end }}
`

func mainPrintResource(resourceKey string, count string, lifecycle string, dynamic bool, doc bool) {
	resourcesMap := k8s.BuildResourcesMap()
	resource := resourcesMap[resourceKey]
	//k8s.Dump(resource)

	var resourceTemplate string
	if dynamic {
		resourceTemplate = resourceTemplateDynamic
	} else {
		resourceTemplate = resourceTemplateStatic
	}

	var templateName string
	if doc {
		templateName = "main_doc"
	} else {
		templateName = "main"
	}

	var t *template.Template
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
			return schema.Type == tfSchema.TypeList
		},
		"isMap": func(schema *tfSchema.Schema) bool {
			return schema.Type == tfSchema.TypeMap
		},
		"backtick": func() string {
			return "```"
		},
		"fmt": func(code string) (string, error) {
			var b bytes.Buffer
			b.Write([]byte(code))
			command := exec.Command("terraform", "fmt", "-")
			command.Stdin = &b
			cmdOut, err := command.CombinedOutput()
			if err != nil {
				log.Fatalln(string(cmdOut))
			}
			return string(cmdOut), err
		},
		"execute": func(data ...interface{}) (string, error) {
			buf := &bytes.Buffer{}
			err := t.ExecuteTemplate(buf, data[0].(string), data[1])
			return buf.String(), err
		},
	}).Parse(resourceTemplate + docTemplate)
	if err != nil {
		panic(err)
	}

	data := ResourceData{
		ResourceKey: resourceKey,
		Count:       count,
		Lifecycle:   lifecycle,
		Resource:    resource,
	}
	err = t.ExecuteTemplate(os.Stdout, templateName, data)
	if err != nil {
		panic(err)
	}
}
