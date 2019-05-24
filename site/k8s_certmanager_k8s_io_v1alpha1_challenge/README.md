
# resource "k8s_certmanager_k8s_io_v1alpha1_challenge"



  
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

    
- [authz_url](#authz_url)*
- [config](#config)
- [dns_name](#dns_name)*
- [key](#key)*
- [token](#token)*
- [type](#type)*
- [url](#url)*
- [wildcard](#wildcard)*

    
<details>
<summary>issuer_ref</summary><blockquote>

    
- [kind](#kind)
- [name](#name)*

    
</details>

<details>
<summary>solver</summary><blockquote>

    

    
<details>
<summary>selector</summary><blockquote>

    
- [dns_names](#dns_names)
- [match_labels](#match_labels)

    
</details>

</details>

</details>


<details>
<summary>example</summary><blockquote>

```hcl
resource "k8s_certmanager_k8s_io_v1alpha1_challenge" "this" {

  metadata {
    annotations = { "key" = "TypeString" }
    labels      = { "key" = "TypeString" }
    name        = "TypeString"
    namespace   = "TypeString"
  }

  spec {
    authz_url = "TypeString*"
    config    = { "key" = "TypeString" }
    dns_name  = "TypeString*"

    issuer_ref {
      kind = "TypeString"
      name = "TypeString*"
    }
    key = "TypeString*"

    solver {

      selector {
        dns_names    = ["TypeString"]
        match_labels = { "key" = "TypeString" }
      }
    }
    token    = "TypeString*"
    type     = "TypeString*"
    url      = "TypeString*"
    wildcard = "TypeString*"
  }
}


```

</details>

  
## metadata

Standard object's metadata. More info: https://git.k8s.io/community/contributors/devel/api-conventions.md#metadata

    
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



    
#### authz_url

###### Required •  TypeString

AuthzURL is the URL to the ACME Authorization resource that this challenge is a part of.
#### config

######  TypeMap

Config specifies the solver configuration for this challenge. Only **one** of 'config' or 'solver' may be specified, and if both are specified then no action will be performed on the Challenge resource. DEPRECATED: the 'solver' field should be specified instead
#### dns_name

###### Required •  TypeString

DNSName is the identifier that this challenge is for, e.g. example.com.
## issuer_ref

IssuerRef references a properly configured ACME-type Issuer which should be used to create this Challenge. If the Issuer does not exist, processing will be retried. If the Issuer is not an 'ACME' Issuer, an error will be returned and the Challenge will be marked as failed.

    
#### kind

######  TypeString


#### name

###### Required •  TypeString


#### key

###### Required •  TypeString

Key is the ACME challenge key for this challenge
## solver

Solver contains the domain solving configuration that should be used to solve this challenge resource. Only **one** of 'config' or 'solver' may be specified, and if both are specified then no action will be performed on the Challenge resource.

    
## selector

Selector selects a set of DNSNames on the Certificate resource that should be solved using this challenge solver.

    
#### dns_names

######  TypeList

List of DNSNames that can be used to further refine the domains that this solver applies to.
#### match_labels

######  TypeMap

A label selector that is used to refine the set of certificate's that this challenge solver will apply to. TODO: use kubernetes standard types for matchLabels
#### token

###### Required •  TypeString

Token is the ACME challenge token for this challenge.
#### type

###### Required •  TypeString

Type is the type of ACME challenge this resource represents, e.g. "dns01" or "http01"
#### url

###### Required •  TypeString

URL is the URL of the ACME Challenge resource for this challenge. This can be used to lookup details about the status of this challenge.
#### wildcard

###### Required •  TypeString

Wildcard will be true if this challenge is for a wildcard identifier, for example '*.example.com'