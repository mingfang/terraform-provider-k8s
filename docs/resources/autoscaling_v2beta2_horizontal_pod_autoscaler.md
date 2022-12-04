
# resource "k8s_autoscaling_v2beta2_horizontal_pod_autoscaler"

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
<summary>behavior</summary><blockquote>

    

    
<details>
<summary>scale_down</summary><blockquote>

    
- [select_policy](#select_policy)
- [stabilization_window_seconds](#stabilization_window_seconds)

    
<details>
<summary>policies</summary><blockquote>

    
- [period_seconds](#period_seconds)*
- [type](#type)*
- [value](#value)*

    
</details>

</details>

<details>
<summary>scale_up</summary><blockquote>

    
- [select_policy](#select_policy)
- [stabilization_window_seconds](#stabilization_window_seconds)

    
<details>
<summary>policies</summary><blockquote>

    
- [period_seconds](#period_seconds)*
- [type](#type)*
- [value](#value)*

    
</details>

</details>

</details>

<details>
<summary>metrics</summary><blockquote>

    
- [type](#type)*

    
<details>
<summary>container_resource</summary><blockquote>

    
- [container](#container)*
- [name](#name)*

    
<details>
<summary>target</summary><blockquote>

    
- [average_utilization](#average_utilization)
- [average_value](#average_value)
- [type](#type)*
- [value](#value)

    
</details>

</details>

<details>
<summary>external</summary><blockquote>

    

    
<details>
<summary>metric</summary><blockquote>

    
- [name](#name)*

    
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
<summary>target</summary><blockquote>

    
- [average_utilization](#average_utilization)
- [average_value](#average_value)
- [type](#type)*
- [value](#value)

    
</details>

</details>

<details>
<summary>object</summary><blockquote>

    

    
<details>
<summary>described_object</summary><blockquote>

    
- [api_version](#api_version)
- [kind](#kind)*
- [name](#name)*

    
</details>

<details>
<summary>metric</summary><blockquote>

    
- [name](#name)*

    
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
<summary>target</summary><blockquote>

    
- [average_utilization](#average_utilization)
- [average_value](#average_value)
- [type](#type)*
- [value](#value)

    
</details>

</details>

<details>
<summary>pods</summary><blockquote>

    

    
<details>
<summary>metric</summary><blockquote>

    
- [name](#name)*

    
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
<summary>target</summary><blockquote>

    
- [average_utilization](#average_utilization)
- [average_value](#average_value)
- [type](#type)*
- [value](#value)

    
</details>

</details>

<details>
<summary>resource</summary><blockquote>

    
- [name](#name)*

    
<details>
<summary>target</summary><blockquote>

    
- [average_utilization](#average_utilization)
- [average_value](#average_value)
- [type](#type)*
- [value](#value)

    
</details>

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
resource "k8s_autoscaling_v2beta2_horizontal_pod_autoscaler" "this" {

  metadata {
    annotations = { "key" = "TypeString" }
    labels      = { "key" = "TypeString" }
    name        = "TypeString"
    namespace   = "TypeString"
  }

  spec {

    behavior {

      scale_down {

        policies {
          period_seconds = "TypeInt*"
          type           = "TypeString*"
          value          = "TypeInt*"
        }
        select_policy                = "TypeString"
        stabilization_window_seconds = "TypeInt"
      }

      scale_up {

        policies {
          period_seconds = "TypeInt*"
          type           = "TypeString*"
          value          = "TypeInt*"
        }
        select_policy                = "TypeString"
        stabilization_window_seconds = "TypeInt"
      }
    }
    max_replicas = "TypeInt*"

    metrics {

      container_resource {
        container = "TypeString*"
        name      = "TypeString*"

        target {
          average_utilization = "TypeInt"
          average_value       = "TypeString"
          type                = "TypeString*"
          value               = "TypeString"
        }
      }

      external {

        metric {
          name = "TypeString*"

          selector {

            match_expressions {
              key      = "TypeString*"
              operator = "TypeString*"
              values   = ["TypeString"]
            }
            match_labels = { "key" = "TypeString" }
          }
        }

        target {
          average_utilization = "TypeInt"
          average_value       = "TypeString"
          type                = "TypeString*"
          value               = "TypeString"
        }
      }

      object {

        described_object {
          api_version = "TypeString"
          kind        = "TypeString*"
          name        = "TypeString*"
        }

        metric {
          name = "TypeString*"

          selector {

            match_expressions {
              key      = "TypeString*"
              operator = "TypeString*"
              values   = ["TypeString"]
            }
            match_labels = { "key" = "TypeString" }
          }
        }

        target {
          average_utilization = "TypeInt"
          average_value       = "TypeString"
          type                = "TypeString*"
          value               = "TypeString"
        }
      }

      pods {

        metric {
          name = "TypeString*"

          selector {

            match_expressions {
              key      = "TypeString*"
              operator = "TypeString*"
              values   = ["TypeString"]
            }
            match_labels = { "key" = "TypeString" }
          }
        }

        target {
          average_utilization = "TypeInt"
          average_value       = "TypeString"
          type                = "TypeString*"
          value               = "TypeString"
        }
      }

      resource {
        name = "TypeString*"

        target {
          average_utilization = "TypeInt"
          average_value       = "TypeString"
          type                = "TypeString*"
          value               = "TypeString"
        }
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

metadata is the standard object metadata. More info: https://git.k8s.io/community/contributors/devel/sig-architecture/api-conventions.md#metadata

    
#### annotations

######  TypeMap

Annotations is an unstructured key value map stored with a resource that may be set by external tools to store and retrieve arbitrary metadata. They are not queryable and should be preserved when modifying objects. More info: http://kubernetes.io/docs/user-guide/annotations
#### creation_timestamp

######  ReadOnly • TypeString

CreationTimestamp is a timestamp representing the server time when this object was created. It is not guaranteed to be set in happens-before order across separate operations. Clients may not set this value. It is represented in RFC3339 form and is in UTC.

Populated by the system. Read-only. Null for lists. More info: https://git.k8s.io/community/contributors/devel/sig-architecture/api-conventions.md#metadata
#### deletion_grace_period_seconds

######  ReadOnly • TypeInt

Number of seconds allowed for this object to gracefully terminate before it will be removed from the system. Only set when deletionTimestamp is also set. May only be shortened. Read-only.
#### deletion_timestamp

######  ReadOnly • TypeString

DeletionTimestamp is RFC 3339 date and time at which this resource will be deleted. This field is set by the server when a graceful deletion is requested by the user, and is not directly settable by a client. The resource is expected to be deleted (no longer visible from resource lists, and not reachable by name) after the time in this field, once the finalizers list is empty. As long as the finalizers list contains items, deletion is blocked. Once the deletionTimestamp is set, this value may not be unset or be set further into the future, although it may be shortened or the resource may be deleted prior to this time. For example, a user may request that a pod is deleted in 30 seconds. The Kubelet will react by sending a graceful termination signal to the containers in the pod. After that 30 seconds, the Kubelet will send a hard termination signal (SIGKILL) to the container and after cleanup, remove the pod from the API. In the presence of network partitions, this object may still exist after this timestamp, until an administrator or automated process can determine the resource is fully terminated. If not set, graceful deletion of the object has not been requested.

Populated by the system when a graceful deletion is requested. Read-only. More info: https://git.k8s.io/community/contributors/devel/sig-architecture/api-conventions.md#metadata
#### labels

######  TypeMap

Map of string keys and values that can be used to organize and categorize (scope and select) objects. May match selectors of replication controllers and services. More info: http://kubernetes.io/docs/user-guide/labels
#### name

######  TypeString

Name must be unique within a namespace. Is required when creating resources, although some resources may allow a client to request the generation of an appropriate name automatically. Name is primarily intended for creation idempotence and configuration definition. Cannot be updated. More info: http://kubernetes.io/docs/user-guide/identifiers#names
#### namespace

######  TypeString

Namespace defines the space within which each name must be unique. An empty namespace is equivalent to the "default" namespace, but "default" is the canonical representation. Not all objects are required to be scoped to a namespace - the value of this field for those objects will be empty.

Must be a DNS_LABEL. Cannot be updated. More info: http://kubernetes.io/docs/user-guide/namespaces
#### resource_version

######  ReadOnly • TypeString

An opaque value that represents the internal version of this object that can be used by clients to determine when objects have changed. May be used for optimistic concurrency, change detection, and the watch operation on a resource or set of resources. Clients must treat these values as opaque and passed unmodified back to the server. They may only be valid for a particular resource or set of resources.

Populated by the system. Read-only. Value must be treated as opaque by clients and . More info: https://git.k8s.io/community/contributors/devel/sig-architecture/api-conventions.md#concurrency-control-and-consistency
#### self_link

######  ReadOnly • TypeString

SelfLink is a URL representing this object. Populated by the system. Read-only.

DEPRECATED Kubernetes will stop propagating this field in 1.20 release and the field is planned to be removed in 1.21 release.
#### uid

######  ReadOnly • TypeString

UID is the unique in time and space value for this object. It is typically generated by the server on successful creation of a resource and is not allowed to change on PUT operations.

Populated by the system. Read-only. More info: http://kubernetes.io/docs/user-guide/identifiers#uids
## spec

spec is the specification for the behaviour of the autoscaler. More info: https://git.k8s.io/community/contributors/devel/sig-architecture/api-conventions.md#spec-and-status.

    
## behavior

behavior configures the scaling behavior of the target in both Up and Down directions (scaleUp and scaleDown fields respectively). If not set, the default HPAScalingRules for scale up and scale down are used.

    
## scale_down

scaleDown is scaling policy for scaling Down. If not set, the default value is to allow to scale down to minReplicas pods, with a 300 second stabilization window (i.e., the highest recommendation for the last 300sec is used).

    
## policies

policies is a list of potential scaling polices which can be used during scaling. At least one policy must be specified, otherwise the HPAScalingRules will be discarded as invalid

    
#### period_seconds

###### Required •  TypeInt

PeriodSeconds specifies the window of time for which the policy should hold true. PeriodSeconds must be greater than zero and less than or equal to 1800 (30 min).
#### type

###### Required •  TypeString

Type is used to specify the scaling policy.
#### value

###### Required •  TypeInt

Value contains the amount of change which is permitted by the policy. It must be greater than zero
#### select_policy

######  TypeString

selectPolicy is used to specify which policy should be used. If not set, the default value MaxPolicySelect is used.
#### stabilization_window_seconds

######  TypeInt

StabilizationWindowSeconds is the number of seconds for which past recommendations should be considered while scaling up or scaling down. StabilizationWindowSeconds must be greater than or equal to zero and less than or equal to 3600 (one hour). If not set, use the default values: - For scale up: 0 (i.e. no stabilization is done). - For scale down: 300 (i.e. the stabilization window is 300 seconds long).
## scale_up

scaleUp is scaling policy for scaling Up. If not set, the default value is the higher of:
  * increase no more than 4 pods per 60 seconds
  * double the number of pods per 60 seconds
No stabilization is used.

    
## policies

policies is a list of potential scaling polices which can be used during scaling. At least one policy must be specified, otherwise the HPAScalingRules will be discarded as invalid

    
#### period_seconds

###### Required •  TypeInt

PeriodSeconds specifies the window of time for which the policy should hold true. PeriodSeconds must be greater than zero and less than or equal to 1800 (30 min).
#### type

###### Required •  TypeString

Type is used to specify the scaling policy.
#### value

###### Required •  TypeInt

Value contains the amount of change which is permitted by the policy. It must be greater than zero
#### select_policy

######  TypeString

selectPolicy is used to specify which policy should be used. If not set, the default value MaxPolicySelect is used.
#### stabilization_window_seconds

######  TypeInt

StabilizationWindowSeconds is the number of seconds for which past recommendations should be considered while scaling up or scaling down. StabilizationWindowSeconds must be greater than or equal to zero and less than or equal to 3600 (one hour). If not set, use the default values: - For scale up: 0 (i.e. no stabilization is done). - For scale down: 300 (i.e. the stabilization window is 300 seconds long).
#### max_replicas

###### Required •  TypeInt

maxReplicas is the upper limit for the number of replicas to which the autoscaler can scale up. It cannot be less that minReplicas.
## metrics

metrics contains the specifications for which to use to calculate the desired replica count (the maximum replica count across all metrics will be used).  The desired replica count is calculated multiplying the ratio between the target value and the current value by the current number of pods.  Ergo, metrics used must decrease as the pod count is increased, and vice-versa.  See the individual metric source types for more information about how each type of metric must respond. If not set, the default metric will be set to 80% average CPU utilization.

    
## container_resource

container resource refers to a resource metric (such as those specified in requests and limits) known to Kubernetes describing a single container in each pod of the current scale target (e.g. CPU or memory). Such metrics are built in to Kubernetes, and have special scaling options on top of those available to normal per-pod metrics using the "pods" source. This is an alpha feature and can be enabled by the HPAContainerMetrics feature flag.

    
#### container

###### Required •  TypeString

container is the name of the container in the pods of the scaling target
#### name

###### Required •  TypeString

name is the name of the resource in question.
## target

target specifies the target value for the given metric

    
#### average_utilization

######  TypeInt

averageUtilization is the target value of the average of the resource metric across all relevant pods, represented as a percentage of the requested value of the resource for the pods. Currently only valid for Resource metric source type
#### average_value

######  TypeString

averageValue is the target value of the average of the metric across all relevant pods (as a quantity)
#### type

###### Required •  TypeString

type represents whether the metric type is Utilization, Value, or AverageValue
#### value

######  TypeString

value is the target value of the metric (as a quantity).
## external

external refers to a global metric that is not associated with any Kubernetes object. It allows autoscaling based on information coming from components running outside of cluster (for example length of queue in cloud messaging service, or QPS from loadbalancer running outside of cluster).

    
## metric

metric identifies the target metric by name and selector

    
#### name

###### Required •  TypeString

name is the name of the given metric
## selector

selector is the string-encoded form of a standard kubernetes label selector for the given metric When set, it is passed as an additional parameter to the metrics server for more specific metrics scoping. When unset, just the metricName will be used to gather metrics.

    
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

target specifies the target value for the given metric

    
#### average_utilization

######  TypeInt

averageUtilization is the target value of the average of the resource metric across all relevant pods, represented as a percentage of the requested value of the resource for the pods. Currently only valid for Resource metric source type
#### average_value

######  TypeString

averageValue is the target value of the average of the metric across all relevant pods (as a quantity)
#### type

###### Required •  TypeString

type represents whether the metric type is Utilization, Value, or AverageValue
#### value

######  TypeString

value is the target value of the metric (as a quantity).
## object

object refers to a metric describing a single kubernetes object (for example, hits-per-second on an Ingress object).

    
## described_object



    
#### api_version

######  TypeString

API version of the referent
#### kind

###### Required •  TypeString

Kind of the referent; More info: https://git.k8s.io/community/contributors/devel/sig-architecture/api-conventions.md#types-kinds"
#### name

###### Required •  TypeString

Name of the referent; More info: http://kubernetes.io/docs/user-guide/identifiers#names
## metric

metric identifies the target metric by name and selector

    
#### name

###### Required •  TypeString

name is the name of the given metric
## selector

selector is the string-encoded form of a standard kubernetes label selector for the given metric When set, it is passed as an additional parameter to the metrics server for more specific metrics scoping. When unset, just the metricName will be used to gather metrics.

    
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

target specifies the target value for the given metric

    
#### average_utilization

######  TypeInt

averageUtilization is the target value of the average of the resource metric across all relevant pods, represented as a percentage of the requested value of the resource for the pods. Currently only valid for Resource metric source type
#### average_value

######  TypeString

averageValue is the target value of the average of the metric across all relevant pods (as a quantity)
#### type

###### Required •  TypeString

type represents whether the metric type is Utilization, Value, or AverageValue
#### value

######  TypeString

value is the target value of the metric (as a quantity).
## pods

pods refers to a metric describing each pod in the current scale target (for example, transactions-processed-per-second).  The values will be averaged together before being compared to the target value.

    
## metric

metric identifies the target metric by name and selector

    
#### name

###### Required •  TypeString

name is the name of the given metric
## selector

selector is the string-encoded form of a standard kubernetes label selector for the given metric When set, it is passed as an additional parameter to the metrics server for more specific metrics scoping. When unset, just the metricName will be used to gather metrics.

    
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

target specifies the target value for the given metric

    
#### average_utilization

######  TypeInt

averageUtilization is the target value of the average of the resource metric across all relevant pods, represented as a percentage of the requested value of the resource for the pods. Currently only valid for Resource metric source type
#### average_value

######  TypeString

averageValue is the target value of the average of the metric across all relevant pods (as a quantity)
#### type

###### Required •  TypeString

type represents whether the metric type is Utilization, Value, or AverageValue
#### value

######  TypeString

value is the target value of the metric (as a quantity).
## resource

resource refers to a resource metric (such as those specified in requests and limits) known to Kubernetes describing each pod in the current scale target (e.g. CPU or memory). Such metrics are built in to Kubernetes, and have special scaling options on top of those available to normal per-pod metrics using the "pods" source.

    
#### name

###### Required •  TypeString

name is the name of the resource in question.
## target

target specifies the target value for the given metric

    
#### average_utilization

######  TypeInt

averageUtilization is the target value of the average of the resource metric across all relevant pods, represented as a percentage of the requested value of the resource for the pods. Currently only valid for Resource metric source type
#### average_value

######  TypeString

averageValue is the target value of the average of the metric across all relevant pods (as a quantity)
#### type

###### Required •  TypeString

type represents whether the metric type is Utilization, Value, or AverageValue
#### value

######  TypeString

value is the target value of the metric (as a quantity).
#### type

###### Required •  TypeString

type is the type of metric source.  It should be one of "ContainerResource", "External", "Object", "Pods" or "Resource", each mapping to a matching field in the object. Note: "ContainerResource" type is available on when the feature-gate HPAContainerMetrics is enabled
#### min_replicas

######  TypeInt

minReplicas is the lower limit for the number of replicas to which the autoscaler can scale down.  It defaults to 1 pod.  minReplicas is allowed to be 0 if the alpha feature gate HPAScaleToZero is enabled and at least one Object or External metric is configured.  Scaling is active as long as at least one metric value is available.
## scale_target_ref

scaleTargetRef points to the target resource to scale, and is used to the pods for which metrics should be collected, as well as to actually change the replica count.

    
#### api_version

######  TypeString

API version of the referent
#### kind

###### Required •  TypeString

Kind of the referent; More info: https://git.k8s.io/community/contributors/devel/sig-architecture/api-conventions.md#types-kinds"
#### name

###### Required •  TypeString

Name of the referent; More info: http://kubernetes.io/docs/user-guide/identifiers#names