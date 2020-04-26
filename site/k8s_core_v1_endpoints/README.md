
# resource "k8s_core_v1_endpoints"

Endpoints is a collection of endpoints that implement the actual service. Example:
  Name: "mysvc",
  Subsets: [
    {
      Addresses: [{"ip": "10.10.1.1"}, {"ip": "10.10.2.2"}],
      Ports: [{"name": "a", "port": 8675}, {"name": "b", "port": 309}]
    },
    {
      Addresses: [{"ip": "10.10.3.3"}],
      Ports: [{"name": "a", "port": 93}, {"name": "b", "port": 76}]
    },
 ]

  
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
<summary>subsets</summary><blockquote>

    

    
<details>
<summary>addresses</summary><blockquote>

    
- [hostname](#hostname)
- [ip](#ip)*
- [node_name](#node_name)

    
<details>
<summary>target_ref</summary><blockquote>

    
- [api_version](#api_version)
- [field_path](#field_path)
- [kind](#kind)
- [name](#name)
- [namespace](#namespace)
- [resource_version](#resource_version)
- [uid](#uid)

    
</details>

</details>

<details>
<summary>not_ready_addresses</summary><blockquote>

    
- [hostname](#hostname)
- [ip](#ip)*
- [node_name](#node_name)

    
<details>
<summary>target_ref</summary><blockquote>

    
- [api_version](#api_version)
- [field_path](#field_path)
- [kind](#kind)
- [name](#name)
- [namespace](#namespace)
- [resource_version](#resource_version)
- [uid](#uid)

    
</details>

</details>

<details>
<summary>ports</summary><blockquote>

    
- [app_protocol](#app_protocol)
- [name](#name)
- [port](#port)*
- [protocol](#protocol)

    
</details>

</details>


<details>
<summary>example</summary><blockquote>

```hcl
resource "k8s_core_v1_endpoints" "this" {

  metadata {
    annotations = { "key" = "TypeString" }
    labels      = { "key" = "TypeString" }
    name        = "TypeString"
    namespace   = "TypeString"
  }

  subsets {

    addresses {
      hostname  = "TypeString"
      ip        = "TypeString*"
      node_name = "TypeString"

      target_ref {
        api_version      = "TypeString"
        field_path       = "TypeString"
        kind             = "TypeString"
        name             = "TypeString"
        namespace        = "TypeString"
        resource_version = "TypeString"
        uid              = "TypeString"
      }
    }

    not_ready_addresses {
      hostname  = "TypeString"
      ip        = "TypeString*"
      node_name = "TypeString"

      target_ref {
        api_version      = "TypeString"
        field_path       = "TypeString"
        kind             = "TypeString"
        name             = "TypeString"
        namespace        = "TypeString"
        resource_version = "TypeString"
        uid              = "TypeString"
      }
    }

    ports {
      app_protocol = "TypeString"
      name         = "TypeString"
      port         = "TypeInt*"
      protocol     = "TypeString"
    }
  }
}


```

</details>

  
## metadata

Standard object's metadata. More info: https://git.k8s.io/community/contributors/devel/sig-architecture/api-conventions.md#metadata

    
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

Namespace defines the space within each name must be unique. An empty namespace is equivalent to the "default" namespace, but "default" is the canonical representation. Not all objects are required to be scoped to a namespace - the value of this field for those objects will be empty.

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
## subsets

The set of all endpoints is the union of all subsets. Addresses are placed into subsets according to the IPs they share. A single address with multiple ports, some of which are ready and some of which are not (because they come from different containers) will result in the address being displayed in different subsets for the different ports. No address will appear in both Addresses and NotReadyAddresses in the same subset. Sets of addresses and ports that comprise a service.

    
## addresses

IP addresses which offer the related ports that are marked as ready. These endpoints should be considered safe for load balancers and clients to utilize.

    
#### hostname

######  TypeString

The Hostname of this endpoint
#### ip

###### Required •  TypeString

The IP of this endpoint. May not be loopback (127.0.0.0/8), link-local (169.254.0.0/16), or link-local multicast ((224.0.0.0/24). IPv6 is also accepted but not fully supported on all platforms. Also, certain kubernetes components, like kube-proxy, are not IPv6 ready.
#### node_name

######  TypeString

Optional: Node hosting this endpoint. This can be used to determine endpoints local to a node.
## target_ref

Reference to object providing the endpoint.

    
#### api_version

######  TypeString

API version of the referent.
#### field_path

######  TypeString

If referring to a piece of an object instead of an entire object, this string should contain a valid JSON/Go field access statement, such as desiredState.manifest.containers[2]. For example, if the object reference is to a container within a pod, this would take on a value like: "spec.containers{name}" (where "name" refers to the name of the container that triggered the event) or if no container name is specified "spec.containers[2]" (container with index 2 in this pod). This syntax is chosen only to have some well-defined way of referencing a part of an object.
#### kind

######  TypeString

Kind of the referent. More info: https://git.k8s.io/community/contributors/devel/sig-architecture/api-conventions.md#types-kinds
#### name

######  TypeString

Name of the referent. More info: https://kubernetes.io/docs/concepts/overview/working-with-objects/names/#names
#### namespace

######  TypeString

Namespace of the referent. More info: https://kubernetes.io/docs/concepts/overview/working-with-objects/namespaces/
#### resource_version

######  TypeString

Specific resourceVersion to which this reference is made, if any. More info: https://git.k8s.io/community/contributors/devel/sig-architecture/api-conventions.md#concurrency-control-and-consistency
#### uid

######  TypeString

UID of the referent. More info: https://kubernetes.io/docs/concepts/overview/working-with-objects/names/#uids
## not_ready_addresses

IP addresses which offer the related ports but are not currently marked as ready because they have not yet finished starting, have recently failed a readiness check, or have recently failed a liveness check.

    
#### hostname

######  TypeString

The Hostname of this endpoint
#### ip

###### Required •  TypeString

The IP of this endpoint. May not be loopback (127.0.0.0/8), link-local (169.254.0.0/16), or link-local multicast ((224.0.0.0/24). IPv6 is also accepted but not fully supported on all platforms. Also, certain kubernetes components, like kube-proxy, are not IPv6 ready.
#### node_name

######  TypeString

Optional: Node hosting this endpoint. This can be used to determine endpoints local to a node.
## target_ref

Reference to object providing the endpoint.

    
#### api_version

######  TypeString

API version of the referent.
#### field_path

######  TypeString

If referring to a piece of an object instead of an entire object, this string should contain a valid JSON/Go field access statement, such as desiredState.manifest.containers[2]. For example, if the object reference is to a container within a pod, this would take on a value like: "spec.containers{name}" (where "name" refers to the name of the container that triggered the event) or if no container name is specified "spec.containers[2]" (container with index 2 in this pod). This syntax is chosen only to have some well-defined way of referencing a part of an object.
#### kind

######  TypeString

Kind of the referent. More info: https://git.k8s.io/community/contributors/devel/sig-architecture/api-conventions.md#types-kinds
#### name

######  TypeString

Name of the referent. More info: https://kubernetes.io/docs/concepts/overview/working-with-objects/names/#names
#### namespace

######  TypeString

Namespace of the referent. More info: https://kubernetes.io/docs/concepts/overview/working-with-objects/namespaces/
#### resource_version

######  TypeString

Specific resourceVersion to which this reference is made, if any. More info: https://git.k8s.io/community/contributors/devel/sig-architecture/api-conventions.md#concurrency-control-and-consistency
#### uid

######  TypeString

UID of the referent. More info: https://kubernetes.io/docs/concepts/overview/working-with-objects/names/#uids
## ports

Port numbers available on the related IP addresses.

    
#### app_protocol

######  TypeString

The application protocol for this port. This field follows standard Kubernetes label syntax. Un-prefixed names are reserved for IANA standard service names (as per RFC-6335 and http://www.iana.org/assignments/service-names). Non-standard protocols should use prefixed names such as mycompany.com/my-custom-protocol. Field can be enabled with ServiceAppProtocol feature gate.
#### name

######  TypeString

The name of this port.  This must match the 'name' field in the corresponding ServicePort. Must be a DNS_LABEL. Optional only if one port is defined.
#### port

###### Required •  TypeInt

The port number of the endpoint.
#### protocol

######  TypeString

The IP protocol for this port. Must be UDP, TCP, or SCTP. Default is TCP.