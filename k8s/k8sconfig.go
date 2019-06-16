package k8s

import (
	"github.com/hashicorp/terraform/terraform"
	"log"
	"sync"

	tfSchema "github.com/hashicorp/terraform/helper/schema"
	"k8s.io/apimachinery/pkg/api/errors"
	"k8s.io/apimachinery/pkg/api/meta"
	metav1 "k8s.io/apimachinery/pkg/apis/meta/v1"
	"k8s.io/apimachinery/pkg/apis/meta/v1/unstructured"
	"k8s.io/apimachinery/pkg/runtime/schema"
	"k8s.io/cli-runtime/pkg/genericclioptions"
	"k8s.io/client-go/discovery"
	"k8s.io/client-go/dynamic"
	"k8s.io/kube-openapi/pkg/util/proto"
)

var (
	singleton *K8SConfig
	once sync.Once
)

func K8SConfig_Singleton() *K8SConfig {
	once.Do(func() {
		singleton = newK8SConfig()
	})
	return singleton
}

func newK8SConfig() *K8SConfig {
	RESTClientGetter := genericclioptions.NewConfigFlags(true)
	RESTMapper, err := RESTClientGetter.ToRESTMapper()
	if err != nil {
		log.Fatal(err)
	}
	RESTConfig, err := RESTClientGetter.ToRESTConfig()
	if err != nil {
		log.Fatal(err)
	}
	dynamicClient, err := dynamic.NewForConfig(RESTConfig)
	if err != nil {
		log.Fatal(err)
	}
	discoveryClient, err := RESTClientGetter.ToDiscoveryClient()
	if err != nil {
		log.Fatal(err)
	}

	modelsMap := buildModelsMap(discoveryClient)
	tfSchemasMap := buildTFSchemasMap(modelsMap)

	return &K8SConfig{
		RESTMapper:      RESTMapper,
		DynamicClient:   dynamicClient,
		DiscoveryClient: discoveryClient,
		ModelsMap:       modelsMap,
		TFSchemasMap:    tfSchemasMap,
	}
}

type K8SConfig struct {
	RESTMapper      meta.RESTMapper
	DynamicClient   dynamic.Interface
	DiscoveryClient discovery.CachedDiscoveryInterface
	Namespace       string
	cache           sync.Map
	countdownLatch  sync.Map
	mutex           sync.Mutex
	ModelsMap       map[schema.GroupVersionKind]proto.Schema
	TFSchemasMap    map[string]*tfSchema.Schema
	resourceConfigMap sync.Map //*terraform.ResourceConfig
}

func (this *K8SConfig) Get(name string, getOption metav1.GetOptions, gvk *schema.GroupVersionKind, namespace string) (*unstructured.Unstructured, error) {
	id := CreateId(namespace, gvk.Kind, name)
	//log.Println("Get name:", name, "gvk:", gvk, "id:", id)
	//try getting without lock first
	if item, ok := this.cache.Load(id); ok {
		return item.(*unstructured.Unstructured), nil
	}

	this.mutex.Lock()
	defer this.mutex.Unlock()

	//try again with lock
	if item, ok := this.cache.Load(id); ok {
		return item.(*unstructured.Unstructured), nil
	}

	//get one until countdown countdownLatch
	if latch, ok := this.countdownLatch.Load(gvk); ok {
		if latch.(int) == 0 {
			//get all
			if res, err := this.GetAll(gvk, namespace); err != nil {
				return nil, err
			} else {
				for _, item := range res.Items {
					itemName, _, _ := unstructured.NestedString(item.Object, "metadata", "name")
					itemId := CreateId(namespace, gvk.Kind, itemName)
					this.cache.Store(itemId, item.DeepCopy())
				}
			}
		} else {
			//count down
			this.countdownLatch.Store(gvk, latch.(int)-1)
			one, err := this.GetOne(name, gvk, namespace)
			if err != nil {
				return nil, err
			}
			this.cache.Store(id, one)
		}
	} else {
		//todo: make countdown value configurable
		//start countdown
		this.countdownLatch.Store(gvk, 0)
		one, err := this.GetOne(name, gvk, namespace)
		if err != nil {
			return nil, err
		}
		this.cache.Store(id, one)
	}

	//try for the last time now that cache should be loaded
	if item, ok := this.cache.Load(id); ok {
		return item.(*unstructured.Unstructured), nil
	} else {
		return nil, errors.NewNotFound(schema.GroupResource{Group: gvk.Group, Resource: gvk.Kind}, name)
	}
}

func (this *K8SConfig) GetOne(name string, gvk *schema.GroupVersionKind, namespace string) (*unstructured.Unstructured, error) {
	RESTMapping, _ := this.RESTMapper.RESTMapping(schema.GroupKind{Group: gvk.Group, Kind: gvk.Kind}, gvk.Version)
	var resourceClient dynamic.ResourceInterface
	resourceClient = this.DynamicClient.Resource(RESTMapping.Resource)
	if namespace != "" {
		resourceClient = resourceClient.(dynamic.NamespaceableResourceInterface).Namespace(namespace)
	}
	res, err := resourceClient.Get(name, metav1.GetOptions{})
	if err != nil {
		return nil, err
	}
	//log.Println("GetOne name:", name, "gvk:", gvk)
	return res, nil
}

func (this *K8SConfig) GetAll(gvk *schema.GroupVersionKind, namespace string) (*unstructured.UnstructuredList, error) {
	RESTMapping, _ := this.RESTMapper.RESTMapping(schema.GroupKind{Group: gvk.Group, Kind: gvk.Kind}, gvk.Version)
	var resourceClient dynamic.ResourceInterface
	resourceClient = this.DynamicClient.Resource(RESTMapping.Resource)
	if namespace != "" {
		resourceClient = resourceClient.(dynamic.NamespaceableResourceInterface).Namespace(namespace)
	}
	//log.Println("GetAll gvk:", gvk)
	return resourceClient.List(metav1.ListOptions{})
}

func (this *K8SConfig) ForEachAPIResource(callback func(metav1.APIResource, schema.GroupVersionKind)) {
	lists, _ := this.DiscoveryClient.ServerResources()
	for _, list := range lists {
		//log.Println("name:", group.Name, "group:", group.PreferredVersion.GroupVersion, "version:", group.PreferredVersion.Version)
		if len(list.APIResources) == 0 {
			continue
		}
		gv, _ := schema.ParseGroupVersion(list.GroupVersion)
		for _, apiResource := range list.APIResources {
			gvk, _ := this.RESTMapper.KindFor(schema.GroupVersionResource{
				Group:    gv.Group,
				Version:  gv.Version,
				Resource: apiResource.Kind,
			})
			callback(apiResource, gvk)
		}
	}
}

func (this *K8SConfig) LoadResourceConfig(id string) (*terraform.ResourceConfig, bool){
	value, ok:= this.resourceConfigMap.Load(id)
	return value.(*terraform.ResourceConfig), ok
}

func (this *K8SConfig) StoreResourceConfig(id string, resourceConfig *terraform.ResourceConfig){
	this.resourceConfigMap.Store(id, resourceConfig)
}

func buildModelsMap(DiscoveryClient discovery.CachedDiscoveryInterface) map[schema.GroupVersionKind]proto.Schema {
	doc, err := DiscoveryClient.OpenAPISchema()
	if err != nil {
		log.Fatal(err)
	}
	models, _ := proto.NewOpenAPIData(doc)
	//get metadata from this for crd resources without spec
	nsModel := models.LookupModel("io.k8s.api.core.v1.Namespace").(*proto.Kind)
	modelsMap := map[schema.GroupVersionKind]proto.Schema{}
	for _, modelName := range models.ListModels() {
		model := models.LookupModel(modelName)
		if model == nil {
			//log.Println("No Model For ModelName:", modelName)
			continue
		}
		gvkList := parseGroupVersionKind(model)
		for _, gvk := range gvkList {
			if len(gvk.Kind) > 0 && !IsSkipKind(gvk.Kind) {
				//check for crd resources without spec
				if _, isMap := model.(*proto.Map); isMap {
					modelsMap[gvk] = &proto.Kind{
						BaseSchema: model.(*proto.Map).BaseSchema,
						Fields: map[string]proto.Schema{
							"metadata": nsModel.Fields["metadata"],
							"spec":     model.(*proto.Map).SubType, //must be type Arbitrary
						},
					}
				} else {
					modelsMap[gvk] = model
				}
			}
		}
	}
	return modelsMap
}

func buildTFSchemasMap(modelsMap map[schema.GroupVersionKind]proto.Schema) map[string]*tfSchema.Schema {
	schemasMap := map[string]*tfSchema.Schema{}
	for gvk, model := range modelsMap {
		resourceKey := ResourceKey(gvk.Group, gvk.Version, gvk.Kind)
		//log.Println("gvk:", gvk, "resource:", resourceKey)
		if _, hasKey := schemasMap[resourceKey]; hasKey {
			//dups
			//sometimes resources appear more than once
			continue
		}

		schemaVisitor := NewK8S2TFSchemaVisitor(resourceKey)
		model.Accept(schemaVisitor)
		schemasMap[resourceKey] = &schemaVisitor.Schema
	}
	return schemasMap
}

const groupVersionKindExtensionKey = "x-kubernetes-group-version-kind"

func parseGroupVersionKind(s proto.Schema) []schema.GroupVersionKind {
	extensions := s.GetExtensions()

	gvkListResult := []schema.GroupVersionKind{}

	// Get the extensions
	gvkExtension, ok := extensions[groupVersionKindExtensionKey]
	if !ok {
		return []schema.GroupVersionKind{}
	}

	// gvk extension must be a list of at least 1 element.
	gvkList, ok := gvkExtension.([]interface{})
	if !ok {
		return []schema.GroupVersionKind{}
	}

	for _, gvk := range gvkList {
		// gvk extension list must be a map with group, version, and
		// kind fields
		gvkMap, ok := gvk.(map[interface{}]interface{})
		if !ok {
			continue
		}
		group, ok := gvkMap["group"].(string)
		if !ok {
			continue
		}
		version, ok := gvkMap["version"].(string)
		if !ok {
			continue
		}
		kind, ok := gvkMap["kind"].(string)
		if !ok {
			continue
		}

		gvkListResult = append(gvkListResult, schema.GroupVersionKind{
			Group:   group,
			Version: version,
			Kind:    kind,
		})
	}

	return gvkListResult
}
