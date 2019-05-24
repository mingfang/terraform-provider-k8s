
# resource "k8s_autoscaling_v2beta1_horizontal_pod_autoscaler"

HorizontalPodAutoscaler is the configuration for a horizontal pod autoscaler, which automatically manages the replica count of any resource implementing the scale subresource based on the metrics specified.

  
<details>
<summary>metadata</summary><blockquote>

    
- [annotations](#annotations)
- [creation_timestamp](#creation_timestamp)
- [deletion_grace_period_seconds](#deletion_grace_period_seconds)
- [deletion_timestamp](#deletion_timestamp)
- [labels](#labels)
- [name](#name)
- [namespace](#namespace)
- [resource_version](#resource_version)
- [self_link](#self_link)
- [uid](#uid)

    
</details>

<details>
<summary>spec</summary><blockquote>

    
- [max_replicas](#max_replicas)*
- [min_replicas](#min_replicas)

    
<details>
<summary>metrics</summary><blockquote>

    
- [type](#type)*

    
<details>
<summary>external</summary><blockquote>

    
- [metric_name](#metric_name)*
- [target_average_value](#target_average_value)
- [target_value](#target_value)

    
<details>
<summary>metric_selector</summary><blockquote>

    
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
<summary>object</summary><blockquote>

    
- [average_value](#average_value)
- [metric_name](#metric_name)*
- [target_value](#target_value)*

    
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

<details>
<summary>target</summary><blockquote>

    
- [api_version](#api_version)
- [kind](#kind)*
- [name](#name)*

    
</details>

</details>

<details>
<summary>pods</summary><blockquote>

    
- [metric_name](#metric_name)*
- [target_average_value](#target_average_value)*

    
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
<summary>resource</summary><blockquote>

    
- [name](#name)*
- [target_average_utilization](#target_average_utilization)
- [target_average_value](#target_average_value)

    
</details>

</details>

<details>
<summary>scale_target_ref</summary><blockquote>

    
- [api_version](#api_version)
- [kind](#kind)*
- [name](#name)*

    
</details>

</details>


<details>
<summary>example</summary><blockquote>

```hcl
resource "k8s_autoscaling_v2beta1_horizontal_pod_autoscaler" "this" {

  metadata {
    annotations = { "key" = "TypeString" }
    labels      = { "key" = "TypeString" }
    name        = "TypeString"
    namespace   = "TypeString"
  }

  spec {
    max_replicas = "TypeInt*"

    metrics {

      external {
        metric_name = "TypeString*"

        metric_selector {

          match_expressions {
            key      = "TypeString*"
            operator = "TypeString*"
            values   = ["TypeString"]
          }
          match_labels = { "key" = "TypeString" }
        }
        target_average_value = "TypeString"
        target_value         = "TypeString"
      }

      object {
        average_value = "TypeString"
        metric_name   = "TypeString*"

        selector {

          match_expressions {
            key      = "TypeString*"
            operator = "TypeString*"
            values   = ["TypeString"]
          }
          match_labels = { "key" = "TypeString" }
        }

        target {
          api_version = "TypeString"
          kind        = "TypeString*"
          name        = "TypeString*"
        }
        target_value = "TypeString*"
      }

      pods {
        metric_name = "TypeString*"

        selector {

          match_expressions {
            key      = "TypeString*"
            operator = "TypeString*"
            values   = ["TypeString"]
          }
          match_labels = { "key" = "TypeString" }
        }
        target_average_value = "TypeString*"
      }

      resource {
        name                       = "TypeString*"
        target_average_utilization = "TypeInt"
        target_average_value       = "TypeString"
      }
      type = "TypeString*"
    }
    min_replicas = "TypeInt"

    scale_target_ref {
      api_version = "TypeString"
      kind        = "TypeString*"
      name        = "TypeString*"
    }
  }
}


```

</details>

  
## metadata

metadata is the standard object metadata. More info: https://git.k8s.io/community/contributors/devel/api-conventions.md#metadata

    
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
#### resource_version

######  ReadOnly • TypeString

An opaque value that represents the internal version of this object that can be used by clients to determine when objects have changed. May be used for optimistic concurrency, change detection, and the watch operation on a resource or set of resources. Clients must treat these values as opaque and passed unmodified back to the server. They may only be valid for a particular resource or set of resources.

Populated by the system. Read-only. Value must be treated as opaque by clients and . More info: https://git.k8s.io/community/contributors/devel/api-conventions.md#concurrency-control-and-consistency
#### self_link

######  ReadOnly • TypeString

SelfLink is a URL representing this object. Populated by the system. Read-only.
#### uid

######  ReadOnly • TypeString

UID is the unique in time and space value for this object. It is typically generated by the server on successful creation of a resource and is not allowed to change on PUT operations.

Populated by the system. Read-only. More info: http://kubernetes.io/docs/user-guide/identifiers#uids
## spec

spec is the specification for the behaviour of the autoscaler. More info: https://git.k8s.io/community/contributors/devel/api-conventions.md#spec-and-status.

    
#### max_replicas

###### Required •  TypeInt

maxReplicas is the upper limit for the number of replicas to which the autoscaler can scale up. It cannot be less that minReplicas.
## metrics

metrics contains the specifications for which to use to calculate the desired replica count (the maximum replica count across all metrics will be used).  The desired replica count is calculated multiplying the ratio between the target value and the current value by the current number of pods.  Ergo, metrics used must decrease as the pod count is increased, and vice-versa.  See the individual metric source types for more information about how each type of metric must respond.

    
## external

external refers to a global metric that is not associated with any Kubernetes object. It allows autoscaling based on information coming from components running outside of cluster (for example length of queue in cloud messaging service, or QPS from loadbalancer running outside of cluster).

    
#### metric_name

###### Required •  TypeString

metricName is the name of the metric in question.
## metric_selector

metricSelector is used to identify a specific time series within a given metric.

    
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
#### target_average_value

######  TypeString

targetAverageValue is the target per-pod value of global metric (as a quantity). Mutually exclusive with TargetValue.
#### target_value

######  TypeString

targetValue is the target value of the metric (as a quantity). Mutually exclusive with TargetAverageValue.
## object

object refers to a metric describing a single kubernetes object (for example, hits-per-second on an Ingress object).

    
#### average_value

######  TypeString

averageValue is the target value of the average of the metric across all relevant pods (as a quantity)
#### metric_name

###### Required •  TypeString

metricName is the name of the metric in question.
## selector

selector is the string-encoded form of a standard kubernetes label selector for the given metric When set, it is passed as an additional parameter to the metrics server for more specific metrics scoping When unset, just the metricName will be used to gather metrics.

    
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
## target

target is the described Kubernetes object.

    
#### api_version

######  TypeString

API version of the referent
#### kind

###### Required •  TypeString

Kind of the referent; More info: https://git.k8s.io/community/contributors/devel/api-conventions.md#types-kinds"
#### name

###### Required •  TypeString

Name of the referent; More info: http://kubernetes.io/docs/user-guide/identifiers#names
#### target_value

###### Required •  TypeString

targetValue is the target value of the metric (as a quantity).
## pods

pods refers to a metric describing each pod in the current scale target (for example, transactions-processed-per-second).  The values will be averaged together before being compared to the target value.

    
#### metric_name

###### Required •  TypeString

metricName is the name of the metric in question
## selector

selector is the string-encoded form of a standard kubernetes label selector for the given metric When set, it is passed as an additional parameter to the metrics server for more specific metrics scoping When unset, just the metricName will be used to gather metrics.

    
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
#### target_average_value

###### Required •  TypeString

targetAverageValue is the target value of the average of the metric across all relevant pods (as a quantity)
## resource

resource refers to a resource metric (such as those specified in requests and limits) known to Kubernetes describing each pod in the current scale target (e.g. CPU or memory). Such metrics are built in to Kubernetes, and have special scaling options on top of those available to normal per-pod metrics using the "pods" source.

    
#### name

###### Required •  TypeString

name is the name of the resource in question.
#### target_average_utilization

######  TypeInt

targetAverageUtilization is the target value of the average of the resource metric across all relevant pods, represented as a percentage of the requested value of the resource for the pods.
#### target_average_value

######  TypeString

targetAverageValue is the target value of the average of the resource metric across all relevant pods, as a raw value (instead of as a percentage of the request), similar to the "pods" metric source type.
#### type

###### Required •  TypeString

type is the type of metric source.  It should be one of "Object", "Pods" or "Resource", each mapping to a matching field in the object.
#### min_replicas

######  TypeInt

minReplicas is the lower limit for the number of replicas to which the autoscaler can scale down. It defaults to 1 pod.
## scale_target_ref

scaleTargetRef points to the target resource to scale, and is used to the pods for which metrics should be collected, as well as to actually change the replica count.

    
#### api_version

######  TypeString

API version of the referent
#### kind

###### Required •  TypeString

Kind of the referent; More info: https://git.k8s.io/community/contributors/devel/api-conventions.md#types-kinds"
#### name

###### Required •  TypeString

Name of the referent; More info: http://kubernetes.io/docs/user-guide/identifiers#names