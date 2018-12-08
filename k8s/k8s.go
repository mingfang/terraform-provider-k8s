package k8s

import (
	"fmt"
	"log"

	"k8s.io/apimachinery/pkg/api/errors"
	metav1 "k8s.io/apimachinery/pkg/apis/meta/v1"
	"k8s.io/apimachinery/pkg/apis/meta/v1/unstructured"
	"k8s.io/apimachinery/pkg/runtime/schema"
	"k8s.io/apimachinery/pkg/types"
	"k8s.io/client-go/dynamic"
	"k8s.io/kube-openapi/pkg/util/proto"

	"github.com/hashicorp/terraform/helper/resource"
	tfSchema "github.com/hashicorp/terraform/helper/schema"
)

//map gvk to model
func BuildModelsMap(k8sConfig *K8SConfig) map[schema.GroupVersionKind]proto.Schema {
	doc, err := k8sConfig.DiscoveryClient.OpenAPISchema()
	if err != nil {
		log.Fatal(err)
	}
	models, _ := proto.NewOpenAPIData(doc)
	modelsMap := map[schema.GroupVersionKind]proto.Schema{}
	for _, modelName := range models.ListModels() {
		model := models.LookupModel(modelName)
		if model == nil {
			log.Println("No Model For ModelName:", modelName)
			continue
		}
		gvkList := parseGroupVersionKind(model)
		for _, gvk := range gvkList {
			if len(gvk.Kind) > 0 && !IsSkipKind(gvk.Kind) {
				modelsMap[gvk] = model
			}
		}
	}
	return modelsMap
}

func BuildResourcesMap() map[string]*tfSchema.Resource {
	resourcesMap := map[string]*tfSchema.Resource{}

	ForEachAPIResource(func(apiResource metav1.APIResource, gvk schema.GroupVersionKind, modelsMap map[schema.GroupVersionKind]proto.Schema, k8sConfig *K8SConfig) {
		if !ContainsVerb(apiResource.Verbs, "create") || !ContainsVerb(apiResource.Verbs, "get") {
			return
		}

		model := modelsMap[gvk]
		if model == nil {
			log.Println("no model for:", apiResource, gvk)
			return
		}

		resourceKey := ResourceKey(gvk.Group, gvk.Version, apiResource.Kind)
		//log.Println("gvk:", gvk, "resource:", resourceKey)
		if _, hasKey := resourcesMap[resourceKey]; hasKey {
			//dups
			return
		}

		schemaVisitor := NewK8S2TFSchemaVisitor(resourceKey)
		model.Accept(schemaVisitor)
		//todo: lost the top level description here
		resource := schemaVisitor.Schema.Elem.(*tfSchema.Resource)
		isNamespaced := apiResource.Namespaced

		resource.Exists = func(resourceData *tfSchema.ResourceData, meta interface{}) (bool, error) {
			return resourceExists(&gvk, isNamespaced, model, resourceData, meta)
		}
		resource.Create = func(resourceData *tfSchema.ResourceData, meta interface{}) error {
			return resourceCreate(resourceKey, &gvk, isNamespaced, model, resourceData, meta)
		}
		resource.Read = func(resourceData *tfSchema.ResourceData, meta interface{}) error {
			return resourceRead(resourceKey, &gvk, isNamespaced, model, resourceData, meta)
		}
		resource.Update = func(resourceData *tfSchema.ResourceData, meta interface{}) error {
			return resourceUpdate(resourceKey, &gvk, isNamespaced, model, resourceData, meta)
		}
		resource.Delete = func(resourceData *tfSchema.ResourceData, meta interface{}) error {
			return resourceDelete(&gvk, isNamespaced, model, resourceData, meta)
		}
		resource.Importer = &tfSchema.ResourceImporter{
			State: tfSchema.ImportStatePassthrough,
		}

		resourcesMap[resourceKey] = resource
	})

	return resourcesMap
}

//todo: share data between the Build calls to avoid hitting the server
func BuildDataSourcesMap() map[string]*tfSchema.Resource {
	resourcesMap := map[string]*tfSchema.Resource{}

	ForEachAPIResource(func(apiResource metav1.APIResource, gvk schema.GroupVersionKind, modelsMap map[schema.GroupVersionKind]proto.Schema, k8sConfig *K8SConfig) {
		if !ContainsVerb(apiResource.Verbs, "get") {
			return
		}

		model := modelsMap[gvk]
		if model == nil {
			log.Println("no model for:", apiResource, gvk)
			return
		}

		resourceKey := ResourceKey(gvk.Group, gvk.Version, apiResource.Kind)
		//log.Println("gvk:", gvk, "resource:", resourceKey)
		if _, hasKey := resourcesMap[resourceKey]; hasKey {
			//dups
			return
		}

		schemaVisitor := NewK8S2TFSchemaVisitor(resourceKey)
		model.Accept(schemaVisitor)
		//todo: lost the top level description here
		resource := schemaVisitor.Schema.Elem.(*tfSchema.Resource)
		isNamespaced := apiResource.Namespaced

		resource.Read = func(resourceData *tfSchema.ResourceData, meta interface{}) error {
			return datasourceRead(resourceKey, &gvk, isNamespaced, model, resourceData, meta)
		}

		resourcesMap[resourceKey] = resource
	})

	return resourcesMap
}

func datasourceRead(resourceKey string, gvk *schema.GroupVersionKind, isNamespaced bool, model proto.Schema, resourceData *tfSchema.ResourceData, meta interface{}) error {
	k8sConfig := meta.(*K8SConfig)
	name, nameErr := getName(resourceData)
	if nameErr != nil {
		return nameErr
	}
	namespace := getNamespace(isNamespaced, resourceData, k8sConfig)
	resourceData.SetId(CreateId(namespace, gvk.Kind, name))

	return resourceRead(resourceKey, gvk, isNamespaced, model, resourceData, meta)
}

func resourceExists(gvk *schema.GroupVersionKind, isNamespaced bool, model proto.Schema, resourceData *tfSchema.ResourceData, meta interface{}) (bool, error) {
	//log.Println("resourceExists Id:", resourceData.Id())
	k8sConfig := meta.(*K8SConfig)
	namespace, _, name, err := ParseId(resourceData.Id())
	if err != nil {
		return false, err
	}

	if _, err := k8sConfig.Get(name, metav1.GetOptions{}, gvk, namespace); err != nil {
		if statusErr, ok := err.(*errors.StatusError); ok && statusErr.ErrStatus.Code == 404 {
			log.Println("not exists:", resourceData.Id(), "err:", err)
			return false, nil
		} else {
			return false, err
		}
	}
	return true, nil
}

func resourceCreate(resourceKey string, gvk *schema.GroupVersionKind, isNamespaced bool, model proto.Schema, resourceData *tfSchema.ResourceData, meta interface{}) error {
	k8sConfig := meta.(*K8SConfig)
	name, nameErr := getName(resourceData)
	if nameErr != nil {
		return nameErr
	}
	namespace := getNamespace(isNamespaced, resourceData, k8sConfig)

	visitor := NewTF2K8SVisitor(resourceData, "", "", resourceData)
	model.Accept(visitor)
	visitorObject := visitor.Object.(map[string]interface{})

	raw := unstructured.Unstructured{
		Object: visitorObject,
	}

	RESTMapping, restMapperErr := k8sConfig.RESTMapper.RESTMapping(schema.GroupKind{Group: gvk.Group, Kind: gvk.Kind}, gvk.Version)
	if restMapperErr != nil {
		return restMapperErr
	}
	var resourceClient dynamic.ResourceInterface
	resourceClient = k8sConfig.DynamicClient.Resource(RESTMapping.Resource)
	if isNamespaced {
		resourceClient = resourceClient.(dynamic.NamespaceableResourceInterface).Namespace(namespace)
	}
	res, err := resourceClient.Create(&raw, metav1.CreateOptions{})
	if err != nil {
		return err
	}
	//log.Println("create res:", res)

	resourceData.SetId(CreateId(namespace, gvk.Kind, name))
	return setState(resourceKey, res.Object, model, resourceData)
}

func resourceRead(resourceKey string, gvk *schema.GroupVersionKind, isNamespaced bool, model proto.Schema, resourceData *tfSchema.ResourceData, meta interface{}) error {
	//log.Println("resourceRead Id:", resourceData.Id())
	k8sConfig := meta.(*K8SConfig)
	namespace, _, name, nameErr := ParseId(resourceData.Id())
	if nameErr != nil {
		return nameErr
	}

	res, err := k8sConfig.Get(name, metav1.GetOptions{}, gvk, namespace)
	if err != nil {
		return err
	}
	//log.Println("read res:", res)

	return setState(resourceKey, res.Object, model, resourceData)
}

func resourceUpdate(resourceKey string, gvk *schema.GroupVersionKind, isNamespaced bool, model proto.Schema, resourceData *tfSchema.ResourceData, meta interface{}) error {
	k8sConfig := meta.(*K8SConfig)
	namespace, _, name, nameErr := ParseId(resourceData.Id())
	if nameErr != nil {
		return nameErr
	}

	visitor := NewTF2K8SVisitor(resourceData, "", "", resourceData)
	model.Accept(visitor)
	log.Println("ops:", visitor.ops)

	jsonBytes, err := PatchOperations(visitor.ops).MarshalJSON()
	if err != nil {
		return err
	}

	RESTMapping, _ := k8sConfig.RESTMapper.RESTMapping(schema.GroupKind{Group: gvk.Group, Kind: gvk.Kind}, gvk.Version)
	var resourceClient dynamic.ResourceInterface
	resourceClient = k8sConfig.DynamicClient.Resource(RESTMapping.Resource)
	if isNamespaced {
		resourceClient = resourceClient.(dynamic.NamespaceableResourceInterface).Namespace(namespace)
	}
	res, err := resourceClient.Patch(name, types.JSONPatchType, jsonBytes, metav1.UpdateOptions{})
	if err != nil {
		return err
	}
	log.Println("update res:", res)
	return setState(resourceKey, res.Object, model, resourceData)
}

func setState(resourceKey string, state map[string]interface{}, model proto.Schema, resourceData *tfSchema.ResourceData) error {
	visitor := NewK8S2TFReadVisitor(resourceKey, state)
	model.Accept(visitor)
	visitorObject := visitor.Object.([]interface{})[0].(map[string]interface{})

	for key, value := range visitorObject {
		if err := resourceData.Set(ToSnake(key), value); err != nil {
			return err
		}
	}

	return nil
}

func resourceDelete(gvk *schema.GroupVersionKind, isNamespaced bool, model proto.Schema, resourceData *tfSchema.ResourceData, meta interface{}) error {
	//log.Println("resourceDelete Id:", resourceData.Id())
	k8sConfig := meta.(*K8SConfig)
	namespace, _, name, nameErr := ParseId(resourceData.Id())
	if nameErr != nil {
		return nameErr
	}

	RESTMapping, _ := k8sConfig.RESTMapper.RESTMapping(schema.GroupKind{Group: gvk.Group, Kind: gvk.Kind}, gvk.Version)
	var resourceClient dynamic.ResourceInterface
	resourceClient = k8sConfig.DynamicClient.Resource(RESTMapping.Resource)
	if isNamespaced {
		resourceClient = resourceClient.(dynamic.NamespaceableResourceInterface).Namespace(namespace)
	}
	deletePolicy := metav1.DeletePropagationForeground
	err := resourceClient.Delete(name, &metav1.DeleteOptions{PropagationPolicy: &deletePolicy})
	if err != nil {
		return err
	}

	resourceData.SetId("")
	return resource.Retry(resourceData.Timeout(tfSchema.TimeoutDelete), func() *resource.RetryError {
		res, err := k8sConfig.GetOne(name, gvk, namespace)
		log.Println("Deleting:", res, err)
		if statusErr, ok := err.(*errors.StatusError); ok && statusErr.ErrStatus.Code == 404 {
			return resource.NonRetryableError(nil)
		} else {
			return resource.RetryableError(fmt.Errorf("Waiting for %s to be deleted", name))
		}
	})
}

func getName(resourceData *tfSchema.ResourceData) (string, error) {
	name, ok := resourceData.GetOk("metadata.0.name")
	if ok {
		return name.(string), nil
	} else {
		return "", fmt.Errorf("metadata.0.name not found")
	}
}

func getNamespace(isNamespaced bool, resourceData *tfSchema.ResourceData, k8sConfig *K8SConfig) string {
	if !isNamespaced {
		return ""
	}
	namespace := resourceData.Get("metadata.0.namespace").(string)
	if namespace != "" {
		return namespace
	} else {
		return k8sConfig.Namespace
	}
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
