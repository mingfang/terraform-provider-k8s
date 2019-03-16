package main

import (
	"bytes"
	"flag"
	"fmt"
	"io"
	"io/ioutil"
	"log"
	"net/http"
	"os"
	"os/exec"
	"regexp"
	"strings"

	metav1 "k8s.io/apimachinery/pkg/apis/meta/v1"
	"k8s.io/apimachinery/pkg/apis/meta/v1/unstructured"
	"k8s.io/apimachinery/pkg/runtime/schema"
	"k8s.io/apimachinery/pkg/util/yaml"
	"k8s.io/client-go/dynamic"
	"k8s.io/kube-openapi/pkg/util/proto"

	"github.com/mingfang/terraform-provider-k8s/k8s"
)

func main() {
	var filename, namespace, kind, name, dir, url string
	var isImport bool

	flag.StringVar(&filename, "filename", "", "name of file to extract")
	flag.StringVar(&dir, "dir", "", "destination directory")
	flag.StringVar(&url, "url", "", "source url")
	flag.StringVar(&namespace, "namespace", "default", "namespace of resources to extract")
	flag.StringVar(&kind, "kind", "", "kind of resources to extract")
	flag.StringVar(&name, "name", "", "name of resources to extract")
	flag.BoolVar(&isImport, "import", false, "automatically import resources")
	flag.Parse()

	if url != "" {
		extractURL(url, kind, dir)
	} else if filename != "" {
		extractFile(filename, kind, dir)
	} else if namespace != "" || kind != "" || name != "" {
		extractCluster(namespace, kind, name, isImport, dir)
	} else {
		fmt.Println("Usage: -filename <name of file to extract>")
		fmt.Println("Usage: -namespace <namespace> -kind <kind> -name <name>, blank means all")
	}

}
func extractURL(url string, kind string, dir string) {
	resp, err := http.Get(url)
	if err != nil {
		log.Fatal(err)
	}
	defer resp.Body.Close()
	body, err := ioutil.ReadAll(resp.Body)
	//log.Println(string(body))
	extractYamlBytes(body, kind, dir)
}

func extractFile(filename string, kind string, dir string) {
	yamlBytes, yamlErr := ioutil.ReadFile(filename)
	if yamlErr != nil {
		log.Fatal(yamlErr)
	}
	extractYamlBytes(yamlBytes, kind, dir)
}

func extractYamlBytes(yamlBytes []byte, kindFilter string, dir string) {
	k8sConfig := k8s.K8SConfig_Singleton()
	modelsMap := k8sConfig.ModelsMap

	decoder := yaml.NewYAMLToJSONDecoder(bytes.NewReader(yamlBytes))
	object := map[string]interface{}{}
	var decodeErr error
	for {
		decodeErr = decoder.Decode(&object)
		if decodeErr != nil {
			break
		}
		if len(object) == 0 {
			continue
		}
		//log.Println(object)
		group, version, _ := k8s.SplitGroupVersion(object["apiVersion"].(string))
		kind := object["kind"].(string)
		if kindFilter != "" && strings.ToLower(kindFilter) != strings.ToLower(kind) {
			//log.Println("Skip kind:", kind)
			continue
		}
		resourceKey := k8s.ResourceKey(group, version, kind)
		gvk, _ := k8sConfig.RESTMapper.KindFor(schema.GroupVersionResource{
			Group:    group,
			Version:  version,
			Resource: kind,
		})
		model := modelsMap[gvk]
		if model == nil {
			log.Println("No Model For:", kind, gvk)
			continue
		}
		saveK8SasTF(object, model, resourceKey, gvk, dir)
	}
	if decodeErr != nil && decodeErr != io.EOF {
		log.Println(decodeErr)
	}
}

func extractCluster(namespace, kind, name string, isImport bool, dir string) {
	systemNamePattern := regexp.MustCompile(`^system:`)
	var dupDetector = map[string]struct{}{}

	k8sConfig := k8s.K8SConfig_Singleton()
	k8sConfig.ForEachAPIResource(func(apiResource metav1.APIResource, gvk schema.GroupVersionKind, modelsMap map[schema.GroupVersionKind]proto.Schema, k8sConfig *k8s.K8SConfig) {
		if gvk.Version == "v1beta1" {
			//log.Println("Skip v1beta1:", gvk.Group, gvk.Version, gvk.Kind)
			return
		}
		if kind != "" && strings.ToLower(kind) != strings.ToLower(apiResource.Kind) {
			//log.Println("Skip kind:", gvk.Group, gvk.Version, gvk.Kind)
			return
		}
		if !k8s.ContainsVerb(apiResource.Verbs, "create") || !k8s.ContainsVerb(apiResource.Verbs, "get") {
			//log.Println("Skip Verbs:", gvk.Group, gvk.Version, gvk.Kind)
			return
		}
		model := modelsMap[gvk]
		if model == nil {
			//log.Println("No Model For:", gvk)
			return
		}
		resourceKey := k8s.ResourceKey(gvk.Group, gvk.Version, gvk.Kind)
		//log.Println("gvk:", gvk, "resource:", resourceKey)

		//todo: handle dup deploys that comes in as both beta1 and v1
		//todo: prevent dup, some are repeated with category = "all"
		if _, hasKey := dupDetector[resourceKey]; hasKey {
			return
		}
		dupDetector[resourceKey] = struct{}{}

		//todo: add exclude option
		if apiResource.Kind == "Pod" || apiResource.Kind == "ReplicaSet" || apiResource.Kind == "Endpoints" || apiResource.Kind == "APIService" {
			//log.Println("Skip:", apiResource.Kind)
			return
		}

		RESTMapping, _ := k8sConfig.RESTMapper.RESTMapping(schema.GroupKind{Group: gvk.Group, Kind: gvk.Kind}, gvk.Version)
		//todo: get namespace from command line
		var resourceClient dynamic.ResourceInterface
		resourceClient = k8sConfig.DynamicClient.Resource(RESTMapping.Resource)
		if apiResource.Namespaced {
			resourceClient = resourceClient.(dynamic.NamespaceableResourceInterface).Namespace(namespace)
		}
		res, err := resourceClient.List(metav1.ListOptions{})
		if err != nil {
			log.Println(err)
			return
		}
		//log.Println("read res:", res)

		//skip existing resources
		execCommand("terraform", []string{"init"})
		stateList, execErr := execCommand("terraform", []string{"state", "list"})
		if execErr != nil {
			log.Println(string(stateList))
		}

		for _, item := range res.Items {
			itemName, _, _ := unstructured.NestedString(item.Object, "metadata", "name")
			if (name != "" && name != itemName) || systemNamePattern.MatchString(itemName) {
				continue
			}
			saveK8SasTF(item.Object, model, resourceKey, gvk, dir)

			//import
			stateName := resourceKey + "." + k8s.ToSnake(itemName)
			if strings.Contains(stateList, stateName) {
				log.Println("skip import:", stateName)
				continue
			}
			if isImport {
				var id string
				if apiResource.Namespaced {
					id = k8s.CreateId(namespace, gvk.Kind, itemName)
				} else {
					id = k8s.CreateId("", gvk.Kind, itemName)
				}
				log.Printf("terraform import %s.%s %s\n", resourceKey, itemName, id)
				if cmdOut, execErr := execCommand("terraform", []string{"import", stateName, id}); execErr != nil {
					log.Println(string(cmdOut))
				}
			}
		}
	})
}

func execCommand(cmd string, args []string) (string, error) {
	command := exec.Command(cmd, args...)
	command.Env = append(os.Environ(), "TF_LOG=")
	cmdOut, execErr := command.CombinedOutput()
	return string(cmdOut), execErr
}

func saveK8SasTF(itemObject map[string]interface{}, model proto.Schema, resourceKey string, gvk schema.GroupVersionKind, dir string) {
	var buf bytes.Buffer
	name, _, _ := unstructured.NestedString(itemObject, "metadata", "name")
	name = k8s.ToSnake(name)

	visitor := NewK8S2TFPrintVisitor(&buf, fmt.Sprintf("resource \"%s\" \"%s\"", resourceKey, name), resourceKey, itemObject, 0, false)
	model.Accept(visitor)

	filename := k8s.ToSnake(gvk.Kind) + "-" + name + ".tf"
	if dir != "" {
		filename = dir + "/" + filename
	}
	log.Println(filename)
	if err := ioutil.WriteFile(filename, buf.Bytes(), 0644); err != nil {
		log.Fatal("WriteFile err:", err)
	}
}
