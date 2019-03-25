
# resource "k8s_policy_v1beta1_pod_disruption_budget"

PodDisruptionBudget is an object to define the max disruption that can be caused to a collection of pods

  
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

    
<details>
<summary>managed_fields</summary><blockquote>

    
- [api_version](#api_version)
- [fields](#fields)
- [manager](#manager)
- [operation](#operation)
- [time](#time)

    
</details>

</details>

<details>
<summary>spec</summary><blockquote>

    
- [max_unavailable](#max_unavailable)
- [min_available](#min_available)

    
<details>
<summary>selector</summary><blockquote>

    
- [match_labels](#match_labels)

    
<details>
<summary>match_expressions</summary><blockquote>

    
- [key](#key)*
- [operator](#operator)*
- [values](#values)

    
</details>

</details>

</details>


<details>
<summary>example</summary><blockquote>

```hcl
//GENERATE STATIC//k8s_policy_v1beta1_pod_disruption_budget////
resource "k8s_policy_v1beta1_pod_disruption_budget" "this" {


  metadata {
    annotations = { "key" = "TypeString" }
    labels      = { "key" = "TypeString" }

    managed_fields {
      api_version = "TypeString"
      fields      = { "key" = "TypeString" }
      manager     = "TypeString"
      operation   = "TypeString"
      time        = "TypeString"
    }
    name      = "TypeString"
    namespace = "TypeString"
  }

  spec {
    max_unavailable = "TypeString"
    min_available   = "TypeString"

    selector {

      match_expressions {
        // Required
        key = "TypeString"
        // Required
        operator = "TypeString"
        values   = ["TypeString"]
      }
      match_labels = { "key" = "TypeString" }
    }
  }

  lifecycle {

  }
}


```

</details>

  
## metadata



    
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
## managed_fields

ManagedFields maps workflow-id and version to the set of fields that are managed by that workflow. This is mostly for internal housekeeping, and users typically shouldn't need to set or understand this field. A workflow can be the user's name, a controller's name, or the name of a specific apply path like "ci-cd". The set of fields is always in the version that the workflow used when modifying the object.

This field is alpha and can be changed or removed without notice.

    
#### api_version

######  TypeString

APIVersion defines the version of this resource that this field set applies to. The format is "group/version" just like the top-level APIVersion field. It is necessary to track the version of a field set because it cannot be automatically converted.
#### fields

######  TypeMap

Fields identifies a set of fields.
#### manager

######  TypeString

Manager is an identifier of the workflow managing these fields.
#### operation

######  TypeString

Operation is the type of operation which lead to this ManagedFieldsEntry being created. The only valid values for this field are 'Apply' and 'Update'.
#### time

######  TypeString

Time is timestamp of when these fields were set. It should always be empty if Operation is 'Apply'
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
## spec

Specification of the desired behavior of the PodDisruptionBudget.

    
#### max_unavailable

######  TypeString

An eviction is allowed if at most "maxUnavailable" pods selected by "selector" are unavailable after the eviction, i.e. even in absence of the evicted pod. For example, one can prevent all voluntary evictions by specifying 0. This is a mutually exclusive setting with "minAvailable".
#### min_available

######  TypeString

An eviction is allowed if at least "minAvailable" pods selected by "selector" will still be available after the eviction, i.e. even in the absence of the evicted pod.  So for example you can prevent all voluntary evictions by specifying "100%".
## selector

Label query over pods whose evictions are managed by the disruption budget.

    
## match_expressions

matchExpressions is a list of label selector requirements. The requirements are ANDed.

    
#### key

###### Required •  TypeString

key is the label key that the selector applies to.
#### operator

###### Required •  TypeString

operator represents a key's relationship to a set of values. Valid operators are In, NotIn, Exists and DoesNotExist.
#### values

######  TypeList

values is an array of string values. If the operator is In or NotIn, the values array must be non-empty. If the operator is Exists or DoesNotExist, the values array must be empty. This array is replaced during a strategic merge patch.
#### match_labels

######  TypeMap

matchLabels is a map of {key,value} pairs. A single {key,value} in the matchLabels map is equivalent to an element of matchExpressions, whose key field is "key", the operator is "In", and the values array contains only "value". The requirements are ANDed.