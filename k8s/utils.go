package k8s

import (
	"fmt"
	"log"
	"regexp"
	"strings"

	"github.com/davecgh/go-spew/spew"
	tfSchema "github.com/hashicorp/terraform/helper/schema"
)

var forceNewPattern = []*regexp.Regexp{
	regexp.MustCompile(`k8s_.*\.metadata\.name$`),
	regexp.MustCompile(`k8s_.*\.metadata\.namespace$`),
	regexp.MustCompile(`k8s_\w+_\w+_service\.spec\.cluster_ip$`),
	regexp.MustCompile(`k8s_\w+_\w+_deployment\.spec\.selector\.match_labels$`),
	regexp.MustCompile(`k8s_\w+_\w+_deployment\.spec\.strategy`),
	regexp.MustCompile(`k8s_\w+_\w+_stateful_set\.spec\.volume_claim_templates`),
	regexp.MustCompile(`k8s_\w+_\w+_\w+\.spec\.template\.spec\.volumes`),
	regexp.MustCompile(`k8s_\w+_\w+_secret\.type$`),
	regexp.MustCompile(`k8s_\w+_\w+_persistent_volume\.spec`),
	regexp.MustCompile(`k8s_\w+_\w+_role_binding\.role_ref`),
	regexp.MustCompile(`k8s_.*\.spec.access_modes`),
	regexp.MustCompile(`k8s_.*\.parameters`),
}

// path format <resource key>.<object path> e.g. k8s_core_v1_service.metadata.name
func IsForceNewField(path string) bool {
	for _, pattern := range forceNewPattern {
		if pattern.MatchString(path) {
			return true
		}
	}
	return false
}

var skipPaths = []*regexp.Regexp{
	regexp.MustCompile(`^[\w]+\.api_version$`), //redundant; already in resourceKey
	regexp.MustCompile(`^[\w]+\.kind$`),        //redundant; already in resourceKey
	regexp.MustCompile(`.*\.status$`),          //this is actually not part of schema
	regexp.MustCompile(`.*\.metadata\.cluster_name$`),
	regexp.MustCompile(`.*\.metadata\.finalizers$`),
	regexp.MustCompile(`.*\.spec\.finalizers$`),
	regexp.MustCompile(`.*\.metadata\.generate_name$`),
	regexp.MustCompile(`.*\.metadata\.generation$`),
	regexp.MustCompile(`.*\.metadata\.initializers$`),
	regexp.MustCompile(`.*\.metadata\.managed_fields$`),
	regexp.MustCompile(`.*\.metadata\.owner_references$`),
	regexp.MustCompile(`.*\.metadata\.annotations\..*_kubernetes_io/revision`),
	regexp.MustCompile(`.*\.metadata\.annotations\.pv_kubernetes_io/`),
	regexp.MustCompile(`.*\.metadata\.annotations\.volume\.beta\.kubernetes.io/`),
	regexp.MustCompile(`.*\.metadata\.annotations\..*_template_generation`),
}

// path format <resource key>.<object path> e.g. k8s_core_v1_service.metadata.name
func IsSkipPath(path string) bool {
	for _, pattern := range skipPaths {
		//log.Println("isSkipPath:", path)
		if pattern.MatchString(path) {
			//log.Println("SkipPath:", path)
			return true
		}
	}
	return false
}

var keywords = []*regexp.Regexp{
	regexp.MustCompile(`^provisioner`),
}

func IsKeyword(path string) bool {
	for _, pattern := range keywords {
		if pattern.MatchString(path) {
			return true
		}
	}
	return false
}

var skipKinds = map[string]struct{}{
	"CertificateSigningRequest": {},
	"ControllerRevision":        {},
	"Event":                     {},
	"Node":                      {},
	"Lease":                     {},
}

func IsSkipKind(kind string) bool {
	_, found := skipKinds[kind]
	return found
}

// groupVersion format <group>/<version
func SplitGroupVersion(groupVersion string) (group, version string, err error) {
	parts := strings.Split(groupVersion, "/")
	switch len(parts) {
	case 1:
		// version only, no group
		return "", parts[0], nil
	case 2:
		// group and version
		return parts[0], parts[1], nil
	}

	return "", "", fmt.Errorf("unexpected GroupVersion format: %q", groupVersion)
}

// generates key like k8s_core_v1_service
func ResourceKey(group, version, kind string) string {
	if group == "" {
		group = "core"
	}
	return "k8s_" + ToSnake(group) + "_" + version + "_" + ToSnake(kind)
}

// adopted https://github.com/iancoleman/strcase/blob/master/snake.go but ignores numbers and requires min 2 run length
func ToSnake(s string) string {
	del := uint8('_')
	runLen := 0
	s = strings.Trim(s, " ")
	n := ""
	for i, v := range s {
		// treat acronyms as words, eg for JSONData -> JSON is a whole word
		nextCaseIsChanged := false
		if i+1 < len(s) {
			next := s[i+1]
			if (v >= 'A' && v <= 'Z' && next >= 'a' && next <= 'z') || (v >= 'a' && v <= 'z' && next >= 'A' && next <= 'Z') {
				nextCaseIsChanged = true
			}
		}

		if i > 0 && n[len(n)-1] != del && nextCaseIsChanged && runLen > 2 {
			// add underscore if next letter case type is changed
			if v >= 'A' && v <= 'Z' {
				n += string(del) + string(v)
			} else if v >= 'a' && v <= 'z' {
				n += string(v) + string(del)
			}
			runLen = 0
		} else if v == ' ' || v == '_' || v == '.' || v == ':' {
			// replace spaces/underscores with delimiters
			n += string(del)
			runLen = 0
		} else {
			n = n + string(v)
			runLen++
		}
	}

	n = strings.ToLower(n)

	// avoid conflict with Terraform keywords
	if IsKeyword(n) {
		n = "_" + n
	}

	return n
}

func CreateId(namespace string, kind string, name string) string {
	return namespace + "." + ToSnake(kind) + "." + name
}

var idPattern = regexp.MustCompile(`^([^.]*)\.([^.]+)\.(.+)$`)

func ParseId(id string) (string, string, string, error) {
	parts := idPattern.FindStringSubmatch(id)

	if len(parts) != 4 {
		err := fmt.Errorf("Unexpected ID format (%q), expected %q.", id, "namespace.kind.name")
		return "", "", "", err
	}

	return parts[1], parts[2], parts[3], nil
}

func Dump(object interface{}) {
	spew.Config.Indent = "  "
	spew.Config.DisablePointerMethods = true
	spew.Config.DisablePointerAddresses = true
	spew.Config.DisableCapacities = true
	log.Println(spew.Sdump(object))
}

func PrintKeys(data map[string]struct{}) {
	keys := make([]string, len(data))
	for key := range data {
		keys = append(keys, key)
	}
	log.Println("keys:", strings.Join(keys, ","))
}

func IsDeprecated(schema *tfSchema.Schema) bool {
	return strings.Contains(schema.Description, "DEPRECATED")
}
