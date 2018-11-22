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
		extractURL(url, dir)
	} else if filename != "" {
		extractFile(filename, dir)
	} else if namespace != "" || kind != "" || name != "" {
		extractCluster(namespace, kind, name, isImport, dir)
	} else {
		fmt.Println("Usage: -filename <name of file to extract>")
		fmt.Println("Usage: -namespace <namespace> -kind <kind> -name <name>, blank means all")
	}

}
func extractURL(url string, dir string) {
	resp, err := http.Get(url)
	if err != nil {
		log.Fatal(err)
	}
	defer resp.Body.Close()
	body, err := ioutil.ReadAll(resp.Body)
	//log.Println(string(body))
	extractYamlBytes(body, dir)
}

func extractFile(filename string, dir string) {
	yamlBytes, yamlErr := ioutil.ReadFile(filename)
	if yamlErr != nil {
		log.Fatal(yamlErr)
	}
	extractYamlBytes(yamlBytes, dir)
}

func extractYamlBytes(yamlBytes []byte, dir string) {
	k8sConfig := k8s.NewK8SConfig()
	modelsMap := k8s.BuildModelsMap(k8sConfig)

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
		resourceKey := k8s.ResourceKey(group, version, kind)
		gvk, _ := k8sConfig.RESTMapper.KindFor(schema.GroupVersionResource{
			Group:    group,
			Version:  version,
			Resource: kind,
		})
		model := modelsMap[gvk]
		if model == nil {
			log.Println("No Model For:", gvk)
			continue
		}
		saveK8SasTF(object, model, resourceKey, gvk, dir)
	}
	if decodeErr != nil && decodeErr != io.EOF {
		log.Println(decodeErr)
	}
}

func extractCluster(namespace, kind, name string, isImport bool, dir string) {
	k8sConfig := k8s.NewK8SConfig()
	modelsMap := k8s.BuildModelsMap(k8sConfig)
	systemNamePattern := regexp.MustCompile(`^system:`)

	var dupDetector = map[string]struct{}{}
	apiResourceLists, _ := k8sConfig.DiscoveryClient.ServerPreferredResources()
	for _, apiResourceList := range apiResourceLists {
		group, version, _ := k8s.SplitGroupVersion(apiResourceList.GroupVersion)
		if version == "v1beta1" {
			log.Println("Skip:", apiResourceList.GroupVersion)
			continue
		}
		for _, apiResource := range apiResourceList.APIResources {
			if kind != "" && strings.ToLower(kind) != strings.ToLower(apiResource.Kind) {
				continue
			}
			if !k8s.ContainsVerb(apiResource.Verbs, "create") || !k8s.ContainsVerb(apiResource.Verbs, "get") {
				continue
			}
			gvk, _ := k8sConfig.RESTMapper.KindFor(schema.GroupVersionResource{
				Group:    group,
				Version:  version,
				Resource: apiResource.Kind,
			})
			model := modelsMap[gvk]
			if model == nil {
				log.Println("No Model For:", gvk)
				continue
			}
			resourceKey := k8s.ResourceKey(gvk.Group, gvk.Version, gvk.Kind)
			//log.Println("gvk:", gvk, "resource:", resourceKey)
			//log.Println(apiResource)

			//todo: handle dup deploys that comes in as both beta1 and v1
			//todo: prevent dup, some are repeated with category = "all"
			if _, hasKey := dupDetector[resourceKey]; hasKey {
				continue
			}
			dupDetector[resourceKey] = struct{}{}

			//todo: add exclude option
			if apiResource.Kind == "Pod" || apiResource.Kind == "ReplicaSet" || apiResource.Kind == "Endpoints" || apiResource.Kind == "APIService" {
				log.Println("Skip:", apiResource.Kind)
				continue
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
				continue
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

		}
	}
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
	fmt.Fprintf(&buf, "resource \"%s\" \"%s\"", resourceKey, name)
	visitor := NewK8S2TFPrintVisitor(&buf, resourceKey, itemObject, 1, false)
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
