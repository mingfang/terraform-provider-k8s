package k8s

import (
	"fmt"
	"log"
	"regexp"
	"strings"

	"github.com/davecgh/go-spew/spew"
	metav1 "k8s.io/apimachinery/pkg/apis/meta/v1"
)

func ContainsVerb(verbs metav1.Verbs, verb string) bool {
	for _, a := range verbs {
		if a == verb {
			return true
		}
	}
	return false
}

var forceNewPattern = []*regexp.Regexp{
	regexp.MustCompile(`k8s_\w+_\w+_\w+\.metadata\.name$`),
	regexp.MustCompile(`k8s_\w+_\w+_\w+\.metadata\.namespace$`),
	regexp.MustCompile(`k8s_\w+_\w+_service\.spec\.cluster_ip$`),
	regexp.MustCompile(`k8s_\w+_\w+_deployment\.spec\.selector\.match_labels$`),
	regexp.MustCompile(`k8s_\w+_\w+_stateful_set\.spec\.volume_claim_templates`),
	regexp.MustCompile(`k8s_\w+_\w+_secret\.type$`),
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
	regexp.MustCompile(`k8s_\w+_\w+_\w+\.api_version$`),
	regexp.MustCompile(`k8s_\w+_\w+_\w+\.kind$`),
	regexp.MustCompile(`.*\.generation$`),
	regexp.MustCompile(`.*\.status$`),
	regexp.MustCompile(`.*\.creation_timestamp$`),
	regexp.MustCompile(`.*\.deletion_timestamp$`),
	regexp.MustCompile(`.*\.owner_references$`),
	regexp.MustCompile(`.*\.paused$`),
	regexp.MustCompile(`.*\.resource_version$`),
	regexp.MustCompile(`.*\.result$`),
	regexp.MustCompile(`.*\.revision_history_limit$`),
	regexp.MustCompile(`.*\.self_link$`),
	regexp.MustCompile(`.*\.template_generation$`),
	regexp.MustCompile(`.*\.uid$`),
	regexp.MustCompile(`.*\.open_apiv3_schema$`),
	regexp.MustCompile(`\.metadata\.annotations\.\w+_kubernetes_io`),
	regexp.MustCompile(`\.metadata\.finalizers$`),
	regexp.MustCompile(`\.spec\.claim_ref`),
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

var skipKinds = map[string]struct{}{
	"APIService":                struct{}{},
	"CertificateSigningRequest": struct{}{},
	"ControllerRevision":        struct{}{},
	"Event":                     struct{}{},
	"Node":                      struct{}{},
	"Lease":                     struct{}{},
	"StorageClass":              struct{}{}, //todo: this caused resource k8s_storage_class: provisioner is a reserved field name
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
	return n
}

func CreateId(namespace string, kind string, name string) string {
	return namespace + "." + ToSnake(kind) + "." + name
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
	for key, _ := range data {
		keys = append(keys, key)
	}
	log.Println("keys:", strings.Join(keys, ","))
}