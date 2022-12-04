
# resource "k8s_networking_k8s_io_v1_ingress"

Ingress is a collection of rules that allow inbound connections to reach the endpoints defined by a backend. An Ingress can be configured to give services externally-reachable urls, load balance traffic, terminate SSL, offer name based virtual hosting etc.

  
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

    
- [ingress_class_name](#ingress_class_name)

    
<details>
<summary>default_backend</summary><blockquote>

    

    
<details>
<summary>resource</summary><blockquote>

    
- [api_group](#api_group)
- [kind](#kind)*
- [name](#name)*

    
</details>

<details>
<summary>service</summary><blockquote>

    
- [name](#name)*

    
<details>
<summary>port</summary><blockquote>

    
- [name](#name)
- [number](#number)

    
</details>

</details>

</details>

<details>
<summary>rules</summary><blockquote>

    
- [host](#host)

    
<details>
<summary>http</summary><blockquote>

    

    
<details>
<summary>paths</summary><blockquote>

    
- [path](#path)
- [path_type](#path_type)

    
<details>
<summary>backend</summary><blockquote>

    

    
<details>
<summary>resource</summary><blockquote>

    
- [api_group](#api_group)
- [kind](#kind)*
- [name](#name)*

    
</details>

<details>
<summary>service</summary><blockquote>

    
- [name](#name)*

    
<details>
<summary>port</summary><blockquote>

    
- [name](#name)
- [number](#number)

    
</details>

</details>

</details>

</details>

</details>

</details>

<details>
<summary>tls</summary><blockquote>

    
- [hosts](#hosts)
- [secret_name](#secret_name)

    
</details>

</details>


<details>
<summary>example</summary><blockquote>

```hcl
resource "k8s_networking_k8s_io_v1_ingress" "this" {

  metadata {
    annotations = { "key" = "TypeString" }
    labels      = { "key" = "TypeString" }
    name        = "TypeString"
    namespace   = "TypeString"
  }

  spec {

    default_backend {

      resource {
        api_group = "TypeString"
        kind      = "TypeString*"
        name      = "TypeString*"
      }

      service {
        name = "TypeString*"

        port {
          name   = "TypeString"
          number = "TypeInt"
        }
      }
    }
    ingress_class_name = "TypeString"

    rules {
      host = "TypeString"

      http {

        paths {

          backend {

            resource {
              api_group = "TypeString"
              kind      = "TypeString*"
              name      = "TypeString*"
            }

            service {
              name = "TypeString*"

              port {
                name   = "TypeString"
                number = "TypeInt"
              }
            }
          }
          path      = "TypeString"
          path_type = "TypeString"
        }
      }
    }

    tls {
      hosts       = ["TypeString"]
      secret_name = "TypeString"
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

Spec is the desired state of the Ingress. More info: https://git.k8s.io/community/contributors/devel/sig-architecture/api-conventions.md#spec-and-status

    
## default_backend

DefaultBackend is the backend that should handle requests that don't match any rule. If Rules are not specified, DefaultBackend must be specified. If DefaultBackend is not set, the handling of requests that do not match any of the rules will be up to the Ingress controller.

    
## resource

Resource is an ObjectRef to another Kubernetes resource in the namespace of the Ingress object. If resource is specified, a service.Name and service.Port must not be specified. This is a mutually exclusive setting with "Service".

    
#### api_group

######  TypeString

APIGroup is the group for the resource being referenced. If APIGroup is not specified, the specified Kind must be in the core API group. For any other third-party types, APIGroup is required.
#### kind

###### Required •  TypeString

Kind is the type of resource being referenced
#### name

###### Required •  TypeString

Name is the name of resource being referenced
## service

Service references a Service as a Backend. This is a mutually exclusive setting with "Resource".

    
#### name

###### Required •  TypeString

Name is the referenced service. The service must exist in the same namespace as the Ingress object.
## port

Port of the referenced service. A port name or port number is required for a IngressServiceBackend.

    
#### name

######  TypeString

Name is the name of the port on the Service. This is a mutually exclusive setting with "Number".
#### number

######  TypeInt

Number is the numerical port number (e.g. 80) on the Service. This is a mutually exclusive setting with "Name".
#### ingress_class_name

######  TypeString

IngressClassName is the name of the IngressClass cluster resource. The associated IngressClass defines which controller will implement the resource. This replaces the deprecated `kubernetes.io/ingress.class` annotation. For backwards compatibility, when that annotation is set, it must be given precedence over this field. The controller may emit a warning if the field and annotation have different values. Implementations of this API should ignore Ingresses without a class specified. An IngressClass resource may be marked as default, which can be used to set a default value for this field. For more information, refer to the IngressClass documentation.
## rules

A list of host rules used to configure the Ingress. If unspecified, or no rule matches, all traffic is sent to the default backend.

    
#### host

######  TypeString

Host is the fully qualified domain name of a network host, as defined by RFC 3986. Note the following deviations from the "host" part of the URI as defined in RFC 3986: 1. IPs are not allowed. Currently an IngressRuleValue can only apply to
   the IP in the Spec of the parent Ingress.
2. The `:` delimiter is not respected because ports are not allowed.
	  Currently the port of an Ingress is implicitly :80 for http and
	  :443 for https.
Both these may change in the future. Incoming requests are matched against the host before the IngressRuleValue. If the host is unspecified, the Ingress routes all traffic based on the specified IngressRuleValue.

Host can be "precise" which is a domain name without the terminating dot of a network host (e.g. "foo.bar.com") or "wildcard", which is a domain name prefixed with a single wildcard label (e.g. "*.foo.com"). The wildcard character '*' must appear by itself as the first DNS label and matches only a single label. You cannot have a wildcard label by itself (e.g. Host == "*"). Requests will be matched against the Host field in the following way: 1. If Host is precise, the request matches this rule if the http host header is equal to Host. 2. If Host is a wildcard, then the request matches this rule if the http host header is to equal to the suffix (removing the first label) of the wildcard rule.
## http



    
## paths

A collection of paths that map requests to backends.

    
## backend

Backend defines the referenced service endpoint to which the traffic will be forwarded to.

    
## resource

Resource is an ObjectRef to another Kubernetes resource in the namespace of the Ingress object. If resource is specified, a service.Name and service.Port must not be specified. This is a mutually exclusive setting with "Service".

    
#### api_group

######  TypeString

APIGroup is the group for the resource being referenced. If APIGroup is not specified, the specified Kind must be in the core API group. For any other third-party types, APIGroup is required.
#### kind

###### Required •  TypeString

Kind is the type of resource being referenced
#### name

###### Required •  TypeString

Name is the name of resource being referenced
## service

Service references a Service as a Backend. This is a mutually exclusive setting with "Resource".

    
#### name

###### Required •  TypeString

Name is the referenced service. The service must exist in the same namespace as the Ingress object.
## port

Port of the referenced service. A port name or port number is required for a IngressServiceBackend.

    
#### name

######  TypeString

Name is the name of the port on the Service. This is a mutually exclusive setting with "Number".
#### number

######  TypeInt

Number is the numerical port number (e.g. 80) on the Service. This is a mutually exclusive setting with "Name".
#### path

######  TypeString

Path is matched against the path of an incoming request. Currently it can contain characters disallowed from the conventional "path" part of a URL as defined by RFC 3986. Paths must begin with a '/'. When unspecified, all paths from incoming requests are matched.
#### path_type

######  TypeString

PathType determines the interpretation of the Path matching. PathType can be one of the following values: * Exact: Matches the URL path exactly. * Prefix: Matches based on a URL path prefix split by '/'. Matching is
  done on a path element by element basis. A path element refers is the
  list of labels in the path split by the '/' separator. A request is a
  match for path p if every p is an element-wise prefix of p of the
  request path. Note that if the last element of the path is a substring
  of the last element in request path, it is not a match (e.g. /foo/bar
  matches /foo/bar/baz, but does not match /foo/barbaz).
* ImplementationSpecific: Interpretation of the Path matching is up to
  the IngressClass. Implementations can treat this as a separate PathType
  or treat it identically to Prefix or Exact path types.
Implementations are required to support all path types.
## tls

TLS configuration. Currently the Ingress only supports a single TLS port, 443. If multiple members of this list specify different hosts, they will be multiplexed on the same port according to the hostname specified through the SNI TLS extension, if the ingress controller fulfilling the ingress supports SNI.

    
#### hosts

######  TypeList

Hosts are a list of hosts included in the TLS certificate. The values in this list must match the name/s used in the tlsSecret. Defaults to the wildcard host setting for the loadbalancer controller fulfilling this Ingress, if left unspecified.
#### secret_name

######  TypeString

SecretName is the name of the secret used to terminate TLS traffic on port 443. Field is left optional to allow TLS routing based on SNI hostname alone. If the SNI host in a listener conflicts with the "Host" header field used by an IngressRule, the SNI host is used for termination and value of the Host header is used for routing.