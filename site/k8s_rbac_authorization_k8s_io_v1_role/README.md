
# resource "k8s_rbac_authorization_k8s_io_v1_role"

Role is a namespaced, logical grouping of PolicyRules that can be referenced as a unit by a RoleBinding.

  
<details>
<summary>metadata</summary><blockquote>

    
- [annotations](#annotations)
- [creation_timestamp](#creation_timestamp)
- [deletion_grace_period_seconds](#deletion_grace_period_seconds)
- [deletion_timestamp](#deletion_timestamp)
- [labels](#labels)
- [name](#name)
- [namespace](#namespace)
- [self_link](#self_link)
- [uid](#uid)

    
</details>

<details>
<summary>rules</summary><blockquote>

    
- [api_groups](#api_groups)
- [non_resource_urls](#non_resource_urls)
- [resource_names](#resource_names)
- [resources](#resources)
- [verbs](#verbs)*

    
</details>


<details>
<summary>example</summary><blockquote>

```hcl
//GENERATE STATIC//k8s_rbac_authorization_k8s_io_v1_role////
resource "k8s_rbac_authorization_k8s_io_v1_role" "this" {


  metadata {
    annotations = { "key" = "TypeString" }
    labels      = { "key" = "TypeString" }
    name        = "TypeString"
    namespace   = "TypeString"
  }

  rules {
    api_groups        = ["TypeString"]
    non_resource_urls = ["TypeString"]
    resource_names    = ["TypeString"]
    resources         = ["TypeString"]
    // Required
    verbs = ["TypeString"]
  }

  lifecycle {

  }
}


```

</details>

  
## metadata

Standard object's metadata.

    
#### annotations

######  TypeMap

Annotations is an unstructured key value map stored with a resource that may be set by external tools to store and retrieve arbitrary metadata. They are not queryable and should be preserved when modifying objects. More info: http://kubernetes.io/docs/user-guide/annotations
#### creation_timestamp

######  ReadOnly • TypeString

CreationTimestamp is a timestamp representing the server time when this object was created. It is not guaranteed to be set in happens-before order across separate operations. Clients may not set this value. It is represented in RFC3339 form and is in UTC.

Populated by the system. Read-only. Null for lists. More info: https://git.k8s.io/community/contributors/devel/api-conventions.md#metadata
#### deletion_grace_period_seconds

######  ReadOnly • TypeInt

Number of seconds allowed for this object to gracefully terminate before it will be removed from the system. Only set when deletionTimestamp is also set. May only be shortened. Read-only.
#### deletion_timestamp

######  ReadOnly • TypeString

DeletionTimestamp is RFC 3339 date and time at which this resource will be deleted. This field is set by the server when a graceful deletion is requested by the user, and is not directly settable by a client. The resource is expected to be deleted (no longer visible from resource lists, and not reachable by name) after the time in this field, once the finalizers list is empty. As long as the finalizers list contains items, deletion is blocked. Once the deletionTimestamp is set, this value may not be unset or be set further into the future, although it may be shortened or the resource may be deleted prior to this time. For example, a user may request that a pod is deleted in 30 seconds. The Kubelet will react by sending a graceful termination signal to the containers in the pod. After that 30 seconds, the Kubelet will send a hard termination signal (SIGKILL) to the container and after cleanup, remove the pod from the API. In the presence of network partitions, this object may still exist after this timestamp, until an administrator or automated process can determine the resource is fully terminated. If not set, graceful deletion of the object has not been requested.

Populated by the system when a graceful deletion is requested. Read-only. More info: https://git.k8s.io/community/contributors/devel/api-conventions.md#metadata
#### labels

######  TypeMap

Map of string keys and values that can be used to organize and categorize (scope and select) objects. May match selectors of replication controllers and services. More info: http://kubernetes.io/docs/user-guide/labels
#### name

######  TypeString

Name must be unique within a namespace. Is required when creating resources, although some resources may allow a client to request the generation of an appropriate name automatically. Name is primarily intended for creation idempotence and configuration definition. Cannot be updated. More info: http://kubernetes.io/docs/user-guide/identifiers#names
#### namespace

######  TypeString

Namespace defines the space within each name must be unique. An empty namespace is equivalent to the "default" namespace, but "default" is the canonical representation. Not all objects are required to be scoped to a namespace - the value of this field for those objects will be empty.

Must be a DNS_LABEL. Cannot be updated. More info: http://kubernetes.io/docs/user-guide/namespaces
#### self_link

######  ReadOnly • TypeString

SelfLink is a URL representing this object. Populated by the system. Read-only.
#### uid

######  ReadOnly • TypeString

UID is the unique in time and space value for this object. It is typically generated by the server on successful creation of a resource and is not allowed to change on PUT operations.

Populated by the system. Read-only. More info: http://kubernetes.io/docs/user-guide/identifiers#uids
## rules

Rules holds all the PolicyRules for this Role

    
#### api_groups

######  TypeList

APIGroups is the name of the APIGroup that contains the resources.  If multiple API groups are specified, any action requested against one of the enumerated resources in any API group will be allowed.
#### non_resource_urls

######  TypeList

NonResourceURLs is a set of partial urls that a user should have access to.  *s are allowed, but only as the full, final step in the path Since non-resource URLs are not namespaced, this field is only applicable for ClusterRoles referenced from a ClusterRoleBinding. Rules can either apply to API resources (such as "pods" or "secrets") or non-resource URL paths (such as "/api"),  but not both.
#### resource_names

######  TypeList

ResourceNames is an optional white list of names that the rule applies to.  An empty set means that everything is allowed.
#### resources

######  TypeList

Resources is a list of resources this rule applies to.  ResourceAll represents all resources.
#### verbs

###### Required •  TypeList

Verbs is a list of Verbs that apply to ALL the ResourceKinds and AttributeRestrictions contained in this rule.  VerbAll represents all kinds. self_link

######  ReadOnly • TypeString

SelfLink is a URL representing this object. Populated by the system. Read-only.
#### uid

######  ReadOnly • TypeString

UID is the unique in time and space value for this object. It is typically generated by the server on successful creation of a resource and is not allowed to change on PUT operations.

Populated by the system. Read-only. More info: http://kubernetes.io/docs/user-guide/identifiers#uids
## rules

Rules holds all the PolicyRules for this Role

    
#### api_groups

######  TypeList

APIGroups is the name of the APIGroup that contains the resources.  If multiple API groups are specified, any action requested against one of the enumerated resources in any API group will be allowed.
#### non_resource_urls

######  TypeList

NonResourceURLs is a set of partial urls that a user should have access to.  *s are allowed, but only as the full, final step in the path Since non-resource URLs are not namespaced, this field is only applicable for ClusterRoles referenced from a ClusterRoleBinding. Rules can either apply to API resources (such as "pods" or "secrets") or non-resource URL paths (such as "/api"),  but not both.
#### resource_names

######  TypeList

ResourceNames is an optional white list of names that the rule applies to.  An empty set means that everything is allowed.
#### resources

######  TypeList

Resources is a list of resources this rule applies to.  ResourceAll represents all resources.
#### verbs

###### Required •  TypeList

Verbs is a list of Verbs that apply to ALL the ResourceKinds and AttributeRestrictions contained in this rule.  VerbAll represents all kinds.