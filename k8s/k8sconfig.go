package k8s

import (
	"log"
	"sync"

	"k8s.io/apimachinery/pkg/api/errors"
	"k8s.io/apimachinery/pkg/api/meta"
	metav1 "k8s.io/apimachinery/pkg/apis/meta/v1"
	"k8s.io/apimachinery/pkg/apis/meta/v1/unstructured"
	"k8s.io/apimachinery/pkg/runtime/schema"
	"k8s.io/cli-runtime/pkg/genericclioptions"
	"k8s.io/client-go/discovery"
	"k8s.io/client-go/dynamic"
)

type K8SConfig struct {
	RESTMapper      meta.RESTMapper
	DynamicClient   dynamic.Interface
	DiscoveryClient discovery.CachedDiscoveryInterface
	Namespace       string
	cache           sync.Map
	countdownLatch  sync.Map
	mutex           sync.Mutex
}

func (this *K8SConfig) Get(name string, getOption metav1.GetOptions, gvk *schema.GroupVersionKind, namespace string) (*unstructured.Unstructured, error) {
	id := CreateId(namespace, gvk.Kind, name)
	log.Println("Get name:", name, "gvk:", gvk, "id:", id)
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
			if res, err := this.getAll(gvk, namespace); err != nil {
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
	log.Println("GetOne name:", name, "gvk:", gvk)
	return res, nil
}

func (this *K8SConfig) getAll(gvk *schema.GroupVersionKind, namespace string) (*unstructured.UnstructuredList, error) {
	RESTMapping, _ := this.RESTMapper.RESTMapping(schema.GroupKind{Group: gvk.Group, Kind: gvk.Kind}, gvk.Version)
	var resourceClient dynamic.ResourceInterface
	resourceClient = this.DynamicClient.Resource(RESTMapping.Resource)
	if namespace != "" {
		resourceClient = resourceClient.(dynamic.NamespaceableResourceInterface).Namespace(namespace)
	}
	log.Println("getAll gvk:", gvk)
	return resourceClient.List(metav1.ListOptions{})
}

func NewK8SConfig() *K8SConfig {
	//todo: where is kubeconfig
	kubeconfig := "/kubeconfig"

	RESTClientGetter := &genericclioptions.ConfigFlags{KubeConfig: &kubeconfig}
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

	return &K8SConfig{
		RESTMapper:      RESTMapper,
		DynamicClient:   dynamicClient,
		DiscoveryClient: discoveryClient,
	}
}
