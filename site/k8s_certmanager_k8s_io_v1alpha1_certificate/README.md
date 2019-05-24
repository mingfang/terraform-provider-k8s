
# resource "k8s_certmanager_k8s_io_v1alpha1_certificate"



  
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

    
- [common_name](#common_name)
- [dns_names](#dns_names)
- [duration](#duration)
- [ipaddresses](#ipaddresses)
- [isca](#isca)
- [key_algorithm](#key_algorithm)
- [key_size](#key_size)
- [organization](#organization)
- [renew_before](#renew_before)
- [secret_name](#secret_name)*

    
<details>
<summary>acme</summary><blockquote>

    

    
<details>
<summary>config</summary><blockquote>

    
- [domains](#domains)*

    
</details>

</details>

<details>
<summary>issuer_ref</summary><blockquote>

    
- [kind](#kind)
- [name](#name)*

    
</details>

</details>


<details>
<summary>example</summary><blockquote>

```hcl
resource "k8s_certmanager_k8s_io_v1alpha1_certificate" "this" {

  metadata {
    annotations = { "key" = "TypeString" }
    labels      = { "key" = "TypeString" }
    name        = "TypeString"
    namespace   = "TypeString"
  }

  spec {

    acme {

      config {
        domains = ["TypeString*"]
      }
    }
    common_name = "TypeString"
    dns_names   = ["TypeString"]
    duration    = "TypeString"
    ipaddresses = ["TypeString"]
    isca        = "TypeString"

    issuer_ref {
      kind = "TypeString"
      name = "TypeString*"
    }
    key_algorithm = "TypeString"
    key_size      = "TypeInt"
    organization  = ["TypeString"]
    renew_before  = "TypeString"
    secret_name   = "TypeString*"
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



    
## acme

ACME contains configuration specific to ACME Certificates. Notably, this contains details on how the domain names listed on this Certificate resource should be 'solved', i.e. mapping HTTP01 and DNS01 providers to DNS names.

    
## config



    
#### domains

###### Required •  TypeList

Domains is the list of domains that this SolverConfig applies to.
#### common_name

######  TypeString

CommonName is a common name to be used on the Certificate
#### dns_names

######  TypeList

DNSNames is a list of subject alt names to be used on the Certificate
#### duration

######  TypeString

Certificate default Duration
#### ipaddresses

######  TypeList

IPAddresses is a list of IP addresses to be used on the Certificate
#### isca

######  TypeString

IsCA will mark this Certificate as valid for signing. This implies that the 'signing' usage is set
## issuer_ref

IssuerRef is a reference to the issuer for this certificate. If the 'kind' field is not set, or set to 'Issuer', an Issuer resource with the given name in the same namespace as the Certificate will be used. If the 'kind' field is set to 'ClusterIssuer', a ClusterIssuer with the provided name will be used. The 'name' field in this stanza is required at all times.

    
#### kind

######  TypeString


#### name

###### Required •  TypeString


#### key_algorithm

######  TypeString

KeyAlgorithm is the private key algorithm of the corresponding private key for this certificate. If provided, allowed values are either "rsa" or "ecdsa" If KeyAlgorithm is specified and KeySize is not provided, key size of 256 will be used for "ecdsa" key algorithm and key size of 2048 will be used for "rsa" key algorithm.
#### key_size

######  TypeInt

KeySize is the key bit size of the corresponding private key for this certificate. If provided, value must be between 2048 and 8192 inclusive when KeyAlgorithm is empty or is set to "rsa", and value must be one of (256, 384, 521) when KeyAlgorithm is set to "ecdsa".
#### organization

######  TypeList

Organization is the organization to be used on the Certificate
#### renew_before

######  TypeString

Certificate renew before expiration duration
#### secret_name

###### Required •  TypeString

SecretName is the name of the secret resource to store this secret in