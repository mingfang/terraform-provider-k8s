
# resource "k8s_certmanager_k8s_io_v1alpha1_issuer"



  
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

    
- [self_signed](#self_signed)

    
<details>
<summary>acme</summary><blockquote>

    
- [email](#email)
- [server](#server)*
- [skip_tls_verify](#skip_tls_verify)

    
<details>
<summary>private_key_secret_ref</summary><blockquote>

    
- [key](#key)
- [name](#name)*

    
</details>

<details>
<summary>solvers</summary><blockquote>

    

    
<details>
<summary>selector</summary><blockquote>

    
- [dns_names](#dns_names)
- [match_labels](#match_labels)

    
</details>

</details>

</details>

<details>
<summary>ca</summary><blockquote>

    
- [secret_name](#secret_name)*

    
</details>

<details>
<summary>vault</summary><blockquote>

    
- [cabundle](#cabundle)
- [path](#path)*
- [server](#server)*

    
<details>
<summary>auth</summary><blockquote>

    

    
<details>
<summary>app_role</summary><blockquote>

    
- [path](#path)*
- [role_id](#role_id)*

    
<details>
<summary>secret_ref</summary><blockquote>

    
- [key](#key)
- [name](#name)*

    
</details>

</details>

<details>
<summary>token_secret_ref</summary><blockquote>

    
- [key](#key)
- [name](#name)*

    
</details>

</details>

</details>

<details>
<summary>venafi</summary><blockquote>

    
- [zone](#zone)*

    
<details>
<summary>cloud</summary><blockquote>

    
- [url](#url)*

    
<details>
<summary>api_token_secret_ref</summary><blockquote>

    
- [key](#key)
- [name](#name)*

    
</details>

</details>

<details>
<summary>tpp</summary><blockquote>

    
- [cabundle](#cabundle)
- [url](#url)*

    
<details>
<summary>credentials_ref</summary><blockquote>

    
- [name](#name)*

    
</details>

</details>

</details>

</details>


<details>
<summary>example</summary><blockquote>

```hcl
resource "k8s_certmanager_k8s_io_v1alpha1_issuer" "this" {

  metadata {
    annotations = { "key" = "TypeString" }
    labels      = { "key" = "TypeString" }
    name        = "TypeString"
    namespace   = "TypeString"
  }

  spec {

    acme {
      email = "TypeString"

      private_key_secret_ref {
        key  = "TypeString"
        name = "TypeString*"
      }
      server          = "TypeString*"
      skip_tls_verify = "TypeString"

      solvers {

        selector {
          dns_names    = ["TypeString"]
          match_labels = { "key" = "TypeString" }
        }
      }
    }

    ca {
      secret_name = "TypeString*"
    }
    self_signed = { "key" = "TypeString" }

    vault {

      auth {

        app_role {
          path    = "TypeString*"
          role_id = "TypeString*"

          secret_ref {
            key  = "TypeString"
            name = "TypeString*"
          }
        }

        token_secret_ref {
          key  = "TypeString"
          name = "TypeString*"
        }
      }
      cabundle = "TypeString"
      path     = "TypeString*"
      server   = "TypeString*"
    }

    venafi {

      cloud {

        api_token_secret_ref {
          key  = "TypeString"
          name = "TypeString*"
        }
        url = "TypeString*"
      }

      tpp {
        cabundle = "TypeString"

        credentials_ref {
          name = "TypeString*"
        }
        url = "TypeString*"
      }
      zone = "TypeString*"
    }
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



    
#### email

######  TypeString

Email is the email for this account
## private_key_secret_ref

PrivateKey is the name of a secret containing the private key for this user account.

    
#### key

######  TypeString

The key of the secret to select from. Must be a valid secret key.
#### name

###### Required •  TypeString

Name of the referent. More info: https://kubernetes.io/docs/concepts/overview/working-with-objects/names/#names TODO: Add other useful fields. apiVersion, kind, uid?
#### server

###### Required •  TypeString

Server is the ACME server URL
#### skip_tls_verify

######  TypeString

If true, skip verifying the ACME server TLS certificate
## solvers

Solvers is a list of challenge solvers that will be used to solve ACME challenges for the matching domains.

    
## selector

Selector selects a set of DNSNames on the Certificate resource that should be solved using this challenge solver.

    
#### dns_names

######  TypeList

List of DNSNames that can be used to further refine the domains that this solver applies to.
#### match_labels

######  TypeMap

A label selector that is used to refine the set of certificate's that this challenge solver will apply to. TODO: use kubernetes standard types for matchLabels
## ca



    
#### secret_name

###### Required •  TypeString

SecretName is the name of the secret used to sign Certificates issued by this Issuer.
#### self_signed

######  TypeMap


## vault



    
## auth

Vault authentication

    
## app_role

This Secret contains a AppRole and Secret

    
#### path

###### Required •  TypeString

Where the authentication path is mounted in Vault.
#### role_id

###### Required •  TypeString


## secret_ref



    
#### key

######  TypeString

The key of the secret to select from. Must be a valid secret key.
#### name

###### Required •  TypeString

Name of the referent. More info: https://kubernetes.io/docs/concepts/overview/working-with-objects/names/#names TODO: Add other useful fields. apiVersion, kind, uid?
## token_secret_ref

This Secret contains the Vault token key

    
#### key

######  TypeString

The key of the secret to select from. Must be a valid secret key.
#### name

###### Required •  TypeString

Name of the referent. More info: https://kubernetes.io/docs/concepts/overview/working-with-objects/names/#names TODO: Add other useful fields. apiVersion, kind, uid?
#### cabundle

######  TypeString

Base64 encoded CA bundle to validate Vault server certificate. Only used if the Server URL is using HTTPS protocol. This parameter is ignored for plain HTTP protocol connection. If not set the system root certificates are used to validate the TLS connection.
#### path

###### Required •  TypeString

Vault URL path to the certificate role
#### server

###### Required •  TypeString

Server is the vault connection address
## venafi



    
## cloud

Cloud specifies the Venafi cloud configuration settings. Only one of TPP or Cloud may be specified.

    
## api_token_secret_ref

APITokenSecretRef is a secret key selector for the Venafi Cloud API token.

    
#### key

######  TypeString

The key of the secret to select from. Must be a valid secret key.
#### name

###### Required •  TypeString

Name of the referent. More info: https://kubernetes.io/docs/concepts/overview/working-with-objects/names/#names TODO: Add other useful fields. apiVersion, kind, uid?
#### url

###### Required •  TypeString

URL is the base URL for Venafi Cloud
## tpp

TPP specifies Trust Protection Platform configuration settings. Only one of TPP or Cloud may be specified.

    
#### cabundle

######  TypeString

CABundle is a PEM encoded TLS certifiate to use to verify connections to the TPP instance. If specified, system roots will not be used and the issuing CA for the TPP instance must be verifiable using the provided root. If not specified, the connection will be verified using the cert-manager system root certificates.
## credentials_ref

CredentialsRef is a reference to a Secret containing the username and password for the TPP server. The secret must contain two keys, 'username' and 'password'.

    
#### name

###### Required •  TypeString

Name of the referent. More info: https://kubernetes.io/docs/concepts/overview/working-with-objects/names/#names TODO: Add other useful fields. apiVersion, kind, uid?
#### url

###### Required •  TypeString

URL is the base URL for the Venafi TPP instance
#### zone

###### Required •  TypeString

Zone is the Venafi Policy Zone to use for this issuer. All requests made to the Venafi platform will be restricted by the named zone policy. This field is required.