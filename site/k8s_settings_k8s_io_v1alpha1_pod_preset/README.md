
# resource "k8s_settings_k8s_io_v1alpha1_pod_preset"

PodPreset is a policy resource that defines additional runtime requirements for a Pod.

  
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

    

    
<details>
<summary>env</summary><blockquote>

    
- [name](#name)*
- [value](#value)

    
<details>
<summary>value_from</summary><blockquote>

    

    
<details>
<summary>config_map_keyref</summary><blockquote>

    
- [key](#key)*
- [name](#name)
- [optional](#optional)

    
</details>

<details>
<summary>field_ref</summary><blockquote>

    
- [api_version](#api_version)
- [field_path](#field_path)*

    
</details>

<details>
<summary>resource_field_ref</summary><blockquote>

    
- [container_name](#container_name)
- [divisor](#divisor)
- [resource](#resource)*

    
</details>

<details>
<summary>secret_key_ref</summary><blockquote>

    
- [key](#key)*
- [name](#name)
- [optional](#optional)

    
</details>

</details>

</details>

<details>
<summary>env_from</summary><blockquote>

    
- [prefix](#prefix)

    
<details>
<summary>config_map_ref</summary><blockquote>

    
- [name](#name)
- [optional](#optional)

    
</details>

<details>
<summary>secret_ref</summary><blockquote>

    
- [name](#name)
- [optional](#optional)

    
</details>

</details>

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
<summary>volume_mounts</summary><blockquote>

    
- [mount_path](#mount_path)*
- [mount_propagation](#mount_propagation)
- [name](#name)*
- [read_only](#read_only)
- [sub_path](#sub_path)
- [sub_path_expr](#sub_path_expr)

    
</details>

<details>
<summary>volumes</summary><blockquote>

    
- [name](#name)*

    
<details>
<summary>aws_elastic_block_store</summary><blockquote>

    
- [fstype](#fstype)
- [partition](#partition)
- [read_only](#read_only)
- [volume_id](#volume_id)*

    
</details>

<details>
<summary>azure_disk</summary><blockquote>

    
- [caching_mode](#caching_mode)
- [disk_name](#disk_name)*
- [disk_uri](#disk_uri)*
- [fstype](#fstype)
- [kind](#kind)
- [read_only](#read_only)

    
</details>

<details>
<summary>azure_file</summary><blockquote>

    
- [read_only](#read_only)
- [secret_name](#secret_name)*
- [share_name](#share_name)*

    
</details>

<details>
<summary>cephfs</summary><blockquote>

    
- [monitors](#monitors)*
- [path](#path)
- [read_only](#read_only)
- [secret_file](#secret_file)
- [user](#user)

    
<details>
<summary>secret_ref</summary><blockquote>

    
- [name](#name)

    
</details>

</details>

<details>
<summary>cinder</summary><blockquote>

    
- [fstype](#fstype)
- [read_only](#read_only)
- [volume_id](#volume_id)*

    
<details>
<summary>secret_ref</summary><blockquote>

    
- [name](#name)

    
</details>

</details>

<details>
<summary>config_map</summary><blockquote>

    
- [default_mode](#default_mode)
- [name](#name)
- [optional](#optional)

    
<details>
<summary>items</summary><blockquote>

    
- [key](#key)*
- [mode](#mode)
- [path](#path)*

    
</details>

</details>

<details>
<summary>csi</summary><blockquote>

    
- [driver](#driver)*
- [fstype](#fstype)
- [read_only](#read_only)
- [volume_attributes](#volume_attributes)

    
<details>
<summary>node_publish_secret_ref</summary><blockquote>

    
- [name](#name)

    
</details>

</details>

<details>
<summary>downward_api</summary><blockquote>

    
- [default_mode](#default_mode)

    
<details>
<summary>items</summary><blockquote>

    
- [mode](#mode)
- [path](#path)*

    
<details>
<summary>field_ref</summary><blockquote>

    
- [api_version](#api_version)
- [field_path](#field_path)*

    
</details>

<details>
<summary>resource_field_ref</summary><blockquote>

    
- [container_name](#container_name)
- [divisor](#divisor)
- [resource](#resource)*

    
</details>

</details>

</details>

<details>
<summary>empty_dir</summary><blockquote>

    
- [medium](#medium)
- [size_limit](#size_limit)

    
</details>

<details>
<summary>fc</summary><blockquote>

    
- [fstype](#fstype)
- [lun](#lun)
- [read_only](#read_only)
- [target_wwns](#target_wwns)
- [wwids](#wwids)

    
</details>

<details>
<summary>flex_volume</summary><blockquote>

    
- [driver](#driver)*
- [fstype](#fstype)
- [options](#options)
- [read_only](#read_only)

    
<details>
<summary>secret_ref</summary><blockquote>

    
- [name](#name)

    
</details>

</details>

<details>
<summary>flocker</summary><blockquote>

    
- [dataset_name](#dataset_name)
- [dataset_uuid](#dataset_uuid)

    
</details>

<details>
<summary>gce_persistent_disk</summary><blockquote>

    
- [fstype](#fstype)
- [partition](#partition)
- [pdname](#pdname)*
- [read_only](#read_only)

    
</details>

<details>
<summary>git_repo</summary><blockquote>

    
- [directory](#directory)
- [repository](#repository)*
- [revision](#revision)

    
</details>

<details>
<summary>glusterfs</summary><blockquote>

    
- [endpoints](#endpoints)*
- [path](#path)*
- [read_only](#read_only)

    
</details>

<details>
<summary>host_path</summary><blockquote>

    
- [path](#path)*
- [type](#type)

    
</details>

<details>
<summary>iscsi</summary><blockquote>

    
- [chap_auth_discovery](#chap_auth_discovery)
- [chap_auth_session](#chap_auth_session)
- [fstype](#fstype)
- [initiator_name](#initiator_name)
- [iqn](#iqn)*
- [iscsi_interface](#iscsi_interface)
- [lun](#lun)*
- [portals](#portals)
- [read_only](#read_only)
- [target_portal](#target_portal)*

    
<details>
<summary>secret_ref</summary><blockquote>

    
- [name](#name)

    
</details>

</details>

<details>
<summary>nfs</summary><blockquote>

    
- [path](#path)*
- [read_only](#read_only)
- [server](#server)*

    
</details>

<details>
<summary>persistent_volume_claim</summary><blockquote>

    
- [claim_name](#claim_name)*
- [read_only](#read_only)

    
</details>

<details>
<summary>photon_persistent_disk</summary><blockquote>

    
- [fstype](#fstype)
- [pdid](#pdid)*

    
</details>

<details>
<summary>portworx_volume</summary><blockquote>

    
- [fstype](#fstype)
- [read_only](#read_only)
- [volume_id](#volume_id)*

    
</details>

<details>
<summary>projected</summary><blockquote>

    
- [default_mode](#default_mode)

    
<details>
<summary>sources</summary><blockquote>

    

    
<details>
<summary>config_map</summary><blockquote>

    
- [name](#name)
- [optional](#optional)

    
<details>
<summary>items</summary><blockquote>

    
- [key](#key)*
- [mode](#mode)
- [path](#path)*

    
</details>

</details>

<details>
<summary>downward_api</summary><blockquote>

    

    
<details>
<summary>items</summary><blockquote>

    
- [mode](#mode)
- [path](#path)*

    
<details>
<summary>field_ref</summary><blockquote>

    
- [api_version](#api_version)
- [field_path](#field_path)*

    
</details>

<details>
<summary>resource_field_ref</summary><blockquote>

    
- [container_name](#container_name)
- [divisor](#divisor)
- [resource](#resource)*

    
</details>

</details>

</details>

<details>
<summary>secret</summary><blockquote>

    
- [name](#name)
- [optional](#optional)

    
<details>
<summary>items</summary><blockquote>

    
- [key](#key)*
- [mode](#mode)
- [path](#path)*

    
</details>

</details>

<details>
<summary>service_account_token</summary><blockquote>

    
- [audience](#audience)
- [expiration_seconds](#expiration_seconds)
- [path](#path)*

    
</details>

</details>

</details>

<details>
<summary>quobyte</summary><blockquote>

    
- [group](#group)
- [read_only](#read_only)
- [registry](#registry)*
- [tenant](#tenant)
- [user](#user)
- [volume](#volume)*

    
</details>

<details>
<summary>rbd</summary><blockquote>

    
- [fstype](#fstype)
- [image](#image)*
- [keyring](#keyring)
- [monitors](#monitors)*
- [pool](#pool)
- [read_only](#read_only)
- [user](#user)

    
<details>
<summary>secret_ref</summary><blockquote>

    
- [name](#name)

    
</details>

</details>

<details>
<summary>scale_io</summary><blockquote>

    
- [fstype](#fstype)
- [gateway](#gateway)*
- [protection_domain](#protection_domain)
- [read_only](#read_only)
- [ssl_enabled](#ssl_enabled)
- [storage_mode](#storage_mode)
- [storage_pool](#storage_pool)
- [system](#system)*
- [volume_name](#volume_name)

    
<details>
<summary>secret_ref</summary><blockquote>

    
- [name](#name)

    
</details>

</details>

<details>
<summary>secret</summary><blockquote>

    
- [default_mode](#default_mode)
- [optional](#optional)
- [secret_name](#secret_name)

    
<details>
<summary>items</summary><blockquote>

    
- [key](#key)*
- [mode](#mode)
- [path](#path)*

    
</details>

</details>

<details>
<summary>storageos</summary><blockquote>

    
- [fstype](#fstype)
- [read_only](#read_only)
- [volume_name](#volume_name)
- [volume_namespace](#volume_namespace)

    
<details>
<summary>secret_ref</summary><blockquote>

    
- [name](#name)

    
</details>

</details>

<details>
<summary>vsphere_volume</summary><blockquote>

    
- [fstype](#fstype)
- [storage_policy_id](#storage_policy_id)
- [storage_policy_name](#storage_policy_name)
- [volume_path](#volume_path)*

    
</details>

</details>

</details>


<details>
<summary>example</summary><blockquote>

```hcl
resource "k8s_settings_k8s_io_v1alpha1_pod_preset" "this" {

  metadata {
    annotations = { "key" = "TypeString" }
    labels      = { "key" = "TypeString" }
    name        = "TypeString"
    namespace   = "TypeString"
  }

  spec {

    env {
      name  = "TypeString*"
      value = "TypeString"

      value_from {

        config_map_keyref {
          key      = "TypeString*"
          name     = "TypeString"
          optional = "TypeString"
        }

        field_ref {
          api_version = "TypeString"
          field_path  = "TypeString*"
        }

        resource_field_ref {
          container_name = "TypeString"
          divisor        = "TypeString"
          resource       = "TypeString*"
        }

        secret_key_ref {
          key      = "TypeString*"
          name     = "TypeString"
          optional = "TypeString"
        }
      }
    }

    env_from {

      config_map_ref {
        name     = "TypeString"
        optional = "TypeString"
      }
      prefix = "TypeString"

      secret_ref {
        name     = "TypeString"
        optional = "TypeString"
      }
    }

    selector {

      match_expressions {
        key      = "TypeString*"
        operator = "TypeString*"
        values   = ["TypeString"]
      }
      match_labels = { "key" = "TypeString" }
    }

    volume_mounts {
      mount_path        = "TypeString*"
      mount_propagation = "TypeString"
      name              = "TypeString*"
      read_only         = "TypeString"
      sub_path          = "TypeString"
      sub_path_expr     = "TypeString"
    }

    volumes {

      aws_elastic_block_store {
        fstype    = "TypeString"
        partition = "TypeInt"
        read_only = "TypeString"
        volume_id = "TypeString*"
      }

      azure_disk {
        caching_mode = "TypeString"
        disk_name    = "TypeString*"
        disk_uri     = "TypeString*"
        fstype       = "TypeString"
        kind         = "TypeString"
        read_only    = "TypeString"
      }

      azure_file {
        read_only   = "TypeString"
        secret_name = "TypeString*"
        share_name  = "TypeString*"
      }

      cephfs {
        monitors    = ["TypeString*"]
        path        = "TypeString"
        read_only   = "TypeString"
        secret_file = "TypeString"

        secret_ref {
          name = "TypeString"
        }
        user = "TypeString"
      }

      cinder {
        fstype    = "TypeString"
        read_only = "TypeString"

        secret_ref {
          name = "TypeString"
        }
        volume_id = "TypeString*"
      }

      config_map {
        default_mode = "TypeInt"

        items {
          key  = "TypeString*"
          mode = "TypeInt"
          path = "TypeString*"
        }
        name     = "TypeString"
        optional = "TypeString"
      }

      csi {
        driver = "TypeString*"
        fstype = "TypeString"

        node_publish_secret_ref {
          name = "TypeString"
        }
        read_only         = "TypeString"
        volume_attributes = { "key" = "TypeString" }
      }

      downward_api {
        default_mode = "TypeInt"

        items {

          field_ref {
            api_version = "TypeString"
            field_path  = "TypeString*"
          }
          mode = "TypeInt"
          path = "TypeString*"

          resource_field_ref {
            container_name = "TypeString"
            divisor        = "TypeString"
            resource       = "TypeString*"
          }
        }
      }

      empty_dir {
        medium     = "TypeString"
        size_limit = "TypeString"
      }

      fc {
        fstype      = "TypeString"
        lun         = "TypeInt"
        read_only   = "TypeString"
        target_wwns = ["TypeString"]
        wwids       = ["TypeString"]
      }

      flex_volume {
        driver    = "TypeString*"
        fstype    = "TypeString"
        options   = { "key" = "TypeString" }
        read_only = "TypeString"

        secret_ref {
          name = "TypeString"
        }
      }

      flocker {
        dataset_name = "TypeString"
        dataset_uuid = "TypeString"
      }

      gce_persistent_disk {
        fstype    = "TypeString"
        partition = "TypeInt"
        pdname    = "TypeString*"
        read_only = "TypeString"
      }

      git_repo {
        directory  = "TypeString"
        repository = "TypeString*"
        revision   = "TypeString"
      }

      glusterfs {
        endpoints = "TypeString*"
        path      = "TypeString*"
        read_only = "TypeString"
      }

      host_path {
        path = "TypeString*"
        type = "TypeString"
      }

      iscsi {
        chap_auth_discovery = "TypeString"
        chap_auth_session   = "TypeString"
        fstype              = "TypeString"
        initiator_name      = "TypeString"
        iqn                 = "TypeString*"
        iscsi_interface     = "TypeString"
        lun                 = "TypeInt*"
        portals             = ["TypeString"]
        read_only           = "TypeString"

        secret_ref {
          name = "TypeString"
        }
        target_portal = "TypeString*"
      }
      name = "TypeString*"

      nfs {
        path      = "TypeString*"
        read_only = "TypeString"
        server    = "TypeString*"
      }

      persistent_volume_claim {
        claim_name = "TypeString*"
        read_only  = "TypeString"
      }

      photon_persistent_disk {
        fstype = "TypeString"
        pdid   = "TypeString*"
      }

      portworx_volume {
        fstype    = "TypeString"
        read_only = "TypeString"
        volume_id = "TypeString*"
      }

      projected {
        default_mode = "TypeInt"

        sources {

          config_map {

            items {
              key  = "TypeString*"
              mode = "TypeInt"
              path = "TypeString*"
            }
            name     = "TypeString"
            optional = "TypeString"
          }

          downward_api {

            items {

              field_ref {
                api_version = "TypeString"
                field_path  = "TypeString*"
              }
              mode = "TypeInt"
              path = "TypeString*"

              resource_field_ref {
                container_name = "TypeString"
                divisor        = "TypeString"
                resource       = "TypeString*"
              }
            }
          }

          secret {

            items {
              key  = "TypeString*"
              mode = "TypeInt"
              path = "TypeString*"
            }
            name     = "TypeString"
            optional = "TypeString"
          }

          service_account_token {
            audience           = "TypeString"
            expiration_seconds = "TypeInt"
            path               = "TypeString*"
          }
        }
      }

      quobyte {
        group     = "TypeString"
        read_only = "TypeString"
        registry  = "TypeString*"
        tenant    = "TypeString"
        user      = "TypeString"
        volume    = "TypeString*"
      }

      rbd {
        fstype    = "TypeString"
        image     = "TypeString*"
        keyring   = "TypeString"
        monitors  = ["TypeString*"]
        pool      = "TypeString"
        read_only = "TypeString"

        secret_ref {
          name = "TypeString"
        }
        user = "TypeString"
      }

      scale_io {
        fstype            = "TypeString"
        gateway           = "TypeString*"
        protection_domain = "TypeString"
        read_only         = "TypeString"

        secret_ref {
          name = "TypeString"
        }
        ssl_enabled  = "TypeString"
        storage_mode = "TypeString"
        storage_pool = "TypeString"
        system       = "TypeString*"
        volume_name  = "TypeString"
      }

      secret {
        default_mode = "TypeInt"

        items {
          key  = "TypeString*"
          mode = "TypeInt"
          path = "TypeString*"
        }
        optional    = "TypeString"
        secret_name = "TypeString"
      }

      storageos {
        fstype    = "TypeString"
        read_only = "TypeString"

        secret_ref {
          name = "TypeString"
        }
        volume_name      = "TypeString"
        volume_namespace = "TypeString"
      }

      vsphere_volume {
        fstype              = "TypeString"
        storage_policy_id   = "TypeString"
        storage_policy_name = "TypeString"
        volume_path         = "TypeString*"
      }
    }
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



    
## env

Env defines the collection of EnvVar to inject into containers.

    
#### name

###### Required •  TypeString

Name of the environment variable. Must be a C_IDENTIFIER.
#### value

######  TypeString

Variable references $(VAR_NAME) are expanded using the previous defined environment variables in the container and any service environment variables. If a variable cannot be resolved, the reference in the input string will be unchanged. The $(VAR_NAME) syntax can be escaped with a double $$, ie: $$(VAR_NAME). Escaped references will never be expanded, regardless of whether the variable exists or not. Defaults to "".
## value_from

Source for the environment variable's value. Cannot be used if value is not empty.

    
## config_map_keyref

Selects a key of a ConfigMap.

    
#### key

###### Required •  TypeString

The key to select.
#### name

######  TypeString

Name of the referent. More info: https://kubernetes.io/docs/concepts/overview/working-with-objects/names/#names
#### optional

######  TypeString

Specify whether the ConfigMap or it's key must be defined
## field_ref

Selects a field of the pod: supports metadata.name, metadata.namespace, metadata.labels, metadata.annotations, spec.nodeName, spec.serviceAccountName, status.hostIP, status.podIP.

    
#### api_version

######  TypeString

Version of the schema the FieldPath is written in terms of, defaults to "v1".
#### field_path

###### Required •  TypeString

Path of the field to select in the specified API version.
## resource_field_ref

Selects a resource of the container: only resources limits and requests (limits.cpu, limits.memory, limits.ephemeral-storage, requests.cpu, requests.memory and requests.ephemeral-storage) are currently supported.

    
#### container_name

######  TypeString

Container name: required for volumes, optional for env vars
#### divisor

######  TypeString

Specifies the output format of the exposed resources, defaults to "1"
#### resource

###### Required •  TypeString

Required: resource to select
## secret_key_ref

Selects a key of a secret in the pod's namespace

    
#### key

###### Required •  TypeString

The key of the secret to select from.  Must be a valid secret key.
#### name

######  TypeString

Name of the referent. More info: https://kubernetes.io/docs/concepts/overview/working-with-objects/names/#names
#### optional

######  TypeString

Specify whether the Secret or it's key must be defined
## env_from

EnvFrom defines the collection of EnvFromSource to inject into containers.

    
## config_map_ref

The ConfigMap to select from

    
#### name

######  TypeString

Name of the referent. More info: https://kubernetes.io/docs/concepts/overview/working-with-objects/names/#names
#### optional

######  TypeString

Specify whether the ConfigMap must be defined
#### prefix

######  TypeString

An optional identifier to prepend to each key in the ConfigMap. Must be a C_IDENTIFIER.
## secret_ref

The Secret to select from

    
#### name

######  TypeString

Name of the referent. More info: https://kubernetes.io/docs/concepts/overview/working-with-objects/names/#names
#### optional

######  TypeString

Specify whether the Secret must be defined
## selector

Selector is a label query over a set of resources, in this case pods. Required.

    
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
## volume_mounts

VolumeMounts defines the collection of VolumeMount to inject into containers.

    
#### mount_path

###### Required •  TypeString

Path within the container at which the volume should be mounted.  Must not contain ':'.
#### mount_propagation

######  TypeString

mountPropagation determines how mounts are propagated from the host to container and the other way around. When not set, MountPropagationNone is used. This field is beta in 1.10.
#### name

###### Required •  TypeString

This must match the Name of a Volume.
#### read_only

######  TypeString

Mounted read-only if true, read-write otherwise (false or unspecified). Defaults to false.
#### sub_path

######  TypeString

Path within the volume from which the container's volume should be mounted. Defaults to "" (volume's root).
#### sub_path_expr

######  TypeString

Expanded path within the volume from which the container's volume should be mounted. Behaves similarly to SubPath but environment variable references $(VAR_NAME) are expanded using the container's environment. Defaults to "" (volume's root). SubPathExpr and SubPath are mutually exclusive. This field is alpha in 1.14.
## volumes

Volumes defines the collection of Volume to inject into the pod.

    
## aws_elastic_block_store

AWSElasticBlockStore represents an AWS Disk resource that is attached to a kubelet's host machine and then exposed to the pod. More info: https://kubernetes.io/docs/concepts/storage/volumes#awselasticblockstore

    
#### fstype

######  TypeString

Filesystem type of the volume that you want to mount. Tip: Ensure that the filesystem type is supported by the host operating system. Examples: "ext4", "xfs", "ntfs". Implicitly inferred to be "ext4" if unspecified. More info: https://kubernetes.io/docs/concepts/storage/volumes#awselasticblockstore
#### partition

######  TypeInt

The partition in the volume that you want to mount. If omitted, the default is to mount by volume name. Examples: For volume /dev/sda1, you specify the partition as "1". Similarly, the volume partition for /dev/sda is "0" (or you can leave the property empty).
#### read_only

######  TypeString

Specify "true" to force and set the ReadOnly property in VolumeMounts to "true". If omitted, the default is "false". More info: https://kubernetes.io/docs/concepts/storage/volumes#awselasticblockstore
#### volume_id

###### Required •  TypeString

Unique ID of the persistent disk resource in AWS (Amazon EBS volume). More info: https://kubernetes.io/docs/concepts/storage/volumes#awselasticblockstore
## azure_disk

AzureDisk represents an Azure Data Disk mount on the host and bind mount to the pod.

    
#### caching_mode

######  TypeString

Host Caching mode: None, Read Only, Read Write.
#### disk_name

###### Required •  TypeString

The Name of the data disk in the blob storage
#### disk_uri

###### Required •  TypeString

The URI the data disk in the blob storage
#### fstype

######  TypeString

Filesystem type to mount. Must be a filesystem type supported by the host operating system. Ex. "ext4", "xfs", "ntfs". Implicitly inferred to be "ext4" if unspecified.
#### kind

######  TypeString

Expected values Shared: multiple blob disks per storage account  Dedicated: single blob disk per storage account  Managed: azure managed data disk (only in managed availability set). defaults to shared
#### read_only

######  TypeString

Defaults to false (read/write). ReadOnly here will force the ReadOnly setting in VolumeMounts.
## azure_file

AzureFile represents an Azure File Service mount on the host and bind mount to the pod.

    
#### read_only

######  TypeString

Defaults to false (read/write). ReadOnly here will force the ReadOnly setting in VolumeMounts.
#### secret_name

###### Required •  TypeString

the name of secret that contains Azure Storage Account Name and Key
#### share_name

###### Required •  TypeString

Share Name
## cephfs

CephFS represents a Ceph FS mount on the host that shares a pod's lifetime

    
#### monitors

###### Required •  TypeList

Required: Monitors is a collection of Ceph monitors More info: https://releases.k8s.io/HEAD/examples/volumes/cephfs/README.md#how-to-use-it
#### path

######  TypeString

Optional: Used as the mounted root, rather than the full Ceph tree, default is /
#### read_only

######  TypeString

Optional: Defaults to false (read/write). ReadOnly here will force the ReadOnly setting in VolumeMounts. More info: https://releases.k8s.io/HEAD/examples/volumes/cephfs/README.md#how-to-use-it
#### secret_file

######  TypeString

Optional: SecretFile is the path to key ring for User, default is /etc/ceph/user.secret More info: https://releases.k8s.io/HEAD/examples/volumes/cephfs/README.md#how-to-use-it
## secret_ref

Optional: SecretRef is reference to the authentication secret for User, default is empty. More info: https://releases.k8s.io/HEAD/examples/volumes/cephfs/README.md#how-to-use-it

    
#### name

######  TypeString

Name of the referent. More info: https://kubernetes.io/docs/concepts/overview/working-with-objects/names/#names
#### user

######  TypeString

Optional: User is the rados user name, default is admin More info: https://releases.k8s.io/HEAD/examples/volumes/cephfs/README.md#how-to-use-it
## cinder

Cinder represents a cinder volume attached and mounted on kubelets host machine More info: https://releases.k8s.io/HEAD/examples/mysql-cinder-pd/README.md

    
#### fstype

######  TypeString

Filesystem type to mount. Must be a filesystem type supported by the host operating system. Examples: "ext4", "xfs", "ntfs". Implicitly inferred to be "ext4" if unspecified. More info: https://releases.k8s.io/HEAD/examples/mysql-cinder-pd/README.md
#### read_only

######  TypeString

Optional: Defaults to false (read/write). ReadOnly here will force the ReadOnly setting in VolumeMounts. More info: https://releases.k8s.io/HEAD/examples/mysql-cinder-pd/README.md
## secret_ref

Optional: points to a secret object containing parameters used to connect to OpenStack.

    
#### name

######  TypeString

Name of the referent. More info: https://kubernetes.io/docs/concepts/overview/working-with-objects/names/#names
#### volume_id

###### Required •  TypeString

volume id used to identify the volume in cinder More info: https://releases.k8s.io/HEAD/examples/mysql-cinder-pd/README.md
## config_map

ConfigMap represents a configMap that should populate this volume

    
#### default_mode

######  TypeInt

Optional: mode bits to use on created files by default. Must be a value between 0 and 0777. Defaults to 0644. Directories within the path are not affected by this setting. This might be in conflict with other options that affect the file mode, like fsGroup, and the result can be other mode bits set.
## items

If unspecified, each key-value pair in the Data field of the referenced ConfigMap will be projected into the volume as a file whose name is the key and content is the value. If specified, the listed keys will be projected into the specified paths, and unlisted keys will not be present. If a key is specified which is not present in the ConfigMap, the volume setup will error unless it is marked optional. Paths must be relative and may not contain the '..' path or start with '..'.

    
#### key

###### Required •  TypeString

The key to project.
#### mode

######  TypeInt

Optional: mode bits to use on this file, must be a value between 0 and 0777. If not specified, the volume defaultMode will be used. This might be in conflict with other options that affect the file mode, like fsGroup, and the result can be other mode bits set.
#### path

###### Required •  TypeString

The relative path of the file to map the key to. May not be an absolute path. May not contain the path element '..'. May not start with the string '..'.
#### name

######  TypeString

Name of the referent. More info: https://kubernetes.io/docs/concepts/overview/working-with-objects/names/#names
#### optional

######  TypeString

Specify whether the ConfigMap or it's keys must be defined
## csi

CSI (Container Storage Interface) represents storage that is handled by an external CSI driver (Alpha feature).

    
#### driver

###### Required •  TypeString

Driver is the name of the CSI driver that handles this volume. Consult with your admin for the correct name as registered in the cluster.
#### fstype

######  TypeString

Filesystem type to mount. Ex. "ext4", "xfs", "ntfs". If not provided, the empty value is passed to the associated CSI driver which will determine the default filesystem to apply.
## node_publish_secret_ref

NodePublishSecretRef is a reference to the secret object containing sensitive information to pass to the CSI driver to complete the CSI NodePublishVolume and NodeUnpublishVolume calls. This field is optional, and  may be empty if no secret is required. If the secret object contains more than one secret, all secret references are passed.

    
#### name

######  TypeString

Name of the referent. More info: https://kubernetes.io/docs/concepts/overview/working-with-objects/names/#names
#### read_only

######  TypeString

Specifies a read-only configuration for the volume. Defaults to false (read/write).
#### volume_attributes

######  TypeMap

VolumeAttributes stores driver-specific properties that are passed to the CSI driver. Consult your driver's documentation for supported values.
## downward_api

DownwardAPI represents downward API about the pod that should populate this volume

    
#### default_mode

######  TypeInt

Optional: mode bits to use on created files by default. Must be a value between 0 and 0777. Defaults to 0644. Directories within the path are not affected by this setting. This might be in conflict with other options that affect the file mode, like fsGroup, and the result can be other mode bits set.
## items

Items is a list of downward API volume file

    
## field_ref

Required: Selects a field of the pod: only annotations, labels, name and namespace are supported.

    
#### api_version

######  TypeString

Version of the schema the FieldPath is written in terms of, defaults to "v1".
#### field_path

###### Required •  TypeString

Path of the field to select in the specified API version.
#### mode

######  TypeInt

Optional: mode bits to use on this file, must be a value between 0 and 0777. If not specified, the volume defaultMode will be used. This might be in conflict with other options that affect the file mode, like fsGroup, and the result can be other mode bits set.
#### path

###### Required •  TypeString

Required: Path is  the relative path name of the file to be created. Must not be absolute or contain the '..' path. Must be utf-8 encoded. The first item of the relative path must not start with '..'
## resource_field_ref

Selects a resource of the container: only resources limits and requests (limits.cpu, limits.memory, requests.cpu and requests.memory) are currently supported.

    
#### container_name

######  TypeString

Container name: required for volumes, optional for env vars
#### divisor

######  TypeString

Specifies the output format of the exposed resources, defaults to "1"
#### resource

###### Required •  TypeString

Required: resource to select
## empty_dir

EmptyDir represents a temporary directory that shares a pod's lifetime. More info: https://kubernetes.io/docs/concepts/storage/volumes#emptydir

    
#### medium

######  TypeString

What type of storage medium should back this directory. The default is "" which means to use the node's default medium. Must be an empty string (default) or Memory. More info: https://kubernetes.io/docs/concepts/storage/volumes#emptydir
#### size_limit

######  TypeString

Total amount of local storage required for this EmptyDir volume. The size limit is also applicable for memory medium. The maximum usage on memory medium EmptyDir would be the minimum value between the SizeLimit specified here and the sum of memory limits of all containers in a pod. The default is nil which means that the limit is undefined. More info: http://kubernetes.io/docs/user-guide/volumes#emptydir
## fc

FC represents a Fibre Channel resource that is attached to a kubelet's host machine and then exposed to the pod.

    
#### fstype

######  TypeString

Filesystem type to mount. Must be a filesystem type supported by the host operating system. Ex. "ext4", "xfs", "ntfs". Implicitly inferred to be "ext4" if unspecified.
#### lun

######  TypeInt

Optional: FC target lun number
#### read_only

######  TypeString

Optional: Defaults to false (read/write). ReadOnly here will force the ReadOnly setting in VolumeMounts.
#### target_wwns

######  TypeList

Optional: FC target worldwide names (WWNs)
#### wwids

######  TypeList

Optional: FC volume world wide identifiers (wwids) Either wwids or combination of targetWWNs and lun must be set, but not both simultaneously.
## flex_volume

FlexVolume represents a generic volume resource that is provisioned/attached using an exec based plugin.

    
#### driver

###### Required •  TypeString

Driver is the name of the driver to use for this volume.
#### fstype

######  TypeString

Filesystem type to mount. Must be a filesystem type supported by the host operating system. Ex. "ext4", "xfs", "ntfs". The default filesystem depends on FlexVolume script.
#### options

######  TypeMap

Optional: Extra command options if any.
#### read_only

######  TypeString

Optional: Defaults to false (read/write). ReadOnly here will force the ReadOnly setting in VolumeMounts.
## secret_ref

Optional: SecretRef is reference to the secret object containing sensitive information to pass to the plugin scripts. This may be empty if no secret object is specified. If the secret object contains more than one secret, all secrets are passed to the plugin scripts.

    
#### name

######  TypeString

Name of the referent. More info: https://kubernetes.io/docs/concepts/overview/working-with-objects/names/#names
## flocker

Flocker represents a Flocker volume attached to a kubelet's host machine. This depends on the Flocker control service being running

    
#### dataset_name

######  TypeString

Name of the dataset stored as metadata -> name on the dataset for Flocker should be considered as deprecated
#### dataset_uuid

######  TypeString

UUID of the dataset. This is unique identifier of a Flocker dataset
## gce_persistent_disk

GCEPersistentDisk represents a GCE Disk resource that is attached to a kubelet's host machine and then exposed to the pod. More info: https://kubernetes.io/docs/concepts/storage/volumes#gcepersistentdisk

    
#### fstype

######  TypeString

Filesystem type of the volume that you want to mount. Tip: Ensure that the filesystem type is supported by the host operating system. Examples: "ext4", "xfs", "ntfs". Implicitly inferred to be "ext4" if unspecified. More info: https://kubernetes.io/docs/concepts/storage/volumes#gcepersistentdisk
#### partition

######  TypeInt

The partition in the volume that you want to mount. If omitted, the default is to mount by volume name. Examples: For volume /dev/sda1, you specify the partition as "1". Similarly, the volume partition for /dev/sda is "0" (or you can leave the property empty). More info: https://kubernetes.io/docs/concepts/storage/volumes#gcepersistentdisk
#### pdname

###### Required •  TypeString

Unique name of the PD resource in GCE. Used to identify the disk in GCE. More info: https://kubernetes.io/docs/concepts/storage/volumes#gcepersistentdisk
#### read_only

######  TypeString

ReadOnly here will force the ReadOnly setting in VolumeMounts. Defaults to false. More info: https://kubernetes.io/docs/concepts/storage/volumes#gcepersistentdisk
## git_repo

GitRepo represents a git repository at a particular revision. DEPRECATED: GitRepo is deprecated. To provision a container with a git repo, mount an EmptyDir into an InitContainer that clones the repo using git, then mount the EmptyDir into the Pod's container.

    
#### directory

######  TypeString

Target directory name. Must not contain or start with '..'.  If '.' is supplied, the volume directory will be the git repository.  Otherwise, if specified, the volume will contain the git repository in the subdirectory with the given name.
#### repository

###### Required •  TypeString

Repository URL
#### revision

######  TypeString

Commit hash for the specified revision.
## glusterfs

Glusterfs represents a Glusterfs mount on the host that shares a pod's lifetime. More info: https://releases.k8s.io/HEAD/examples/volumes/glusterfs/README.md

    
#### endpoints

###### Required •  TypeString

EndpointsName is the endpoint name that details Glusterfs topology. More info: https://releases.k8s.io/HEAD/examples/volumes/glusterfs/README.md#create-a-pod
#### path

###### Required •  TypeString

Path is the Glusterfs volume path. More info: https://releases.k8s.io/HEAD/examples/volumes/glusterfs/README.md#create-a-pod
#### read_only

######  TypeString

ReadOnly here will force the Glusterfs volume to be mounted with read-only permissions. Defaults to false. More info: https://releases.k8s.io/HEAD/examples/volumes/glusterfs/README.md#create-a-pod
## host_path

HostPath represents a pre-existing file or directory on the host machine that is directly exposed to the container. This is generally used for system agents or other privileged things that are allowed to see the host machine. Most containers will NOT need this. More info: https://kubernetes.io/docs/concepts/storage/volumes#hostpath

    
#### path

###### Required •  TypeString

Path of the directory on the host. If the path is a symlink, it will follow the link to the real path. More info: https://kubernetes.io/docs/concepts/storage/volumes#hostpath
#### type

######  TypeString

Type for HostPath Volume Defaults to "" More info: https://kubernetes.io/docs/concepts/storage/volumes#hostpath
## iscsi

ISCSI represents an ISCSI Disk resource that is attached to a kubelet's host machine and then exposed to the pod. More info: https://releases.k8s.io/HEAD/examples/volumes/iscsi/README.md

    
#### chap_auth_discovery

######  TypeString

whether support iSCSI Discovery CHAP authentication
#### chap_auth_session

######  TypeString

whether support iSCSI Session CHAP authentication
#### fstype

######  TypeString

Filesystem type of the volume that you want to mount. Tip: Ensure that the filesystem type is supported by the host operating system. Examples: "ext4", "xfs", "ntfs". Implicitly inferred to be "ext4" if unspecified. More info: https://kubernetes.io/docs/concepts/storage/volumes#iscsi
#### initiator_name

######  TypeString

Custom iSCSI Initiator Name. If initiatorName is specified with iscsiInterface simultaneously, new iSCSI interface <target portal>:<volume name> will be created for the connection.
#### iqn

###### Required •  TypeString

Target iSCSI Qualified Name.
#### iscsi_interface

######  TypeString

iSCSI Interface Name that uses an iSCSI transport. Defaults to 'default' (tcp).
#### lun

###### Required •  TypeInt

iSCSI Target Lun number.
#### portals

######  TypeList

iSCSI Target Portal List. The portal is either an IP or ip_addr:port if the port is other than default (typically TCP ports 860 and 3260).
#### read_only

######  TypeString

ReadOnly here will force the ReadOnly setting in VolumeMounts. Defaults to false.
## secret_ref

CHAP Secret for iSCSI target and initiator authentication

    
#### name

######  TypeString

Name of the referent. More info: https://kubernetes.io/docs/concepts/overview/working-with-objects/names/#names
#### target_portal

###### Required •  TypeString

iSCSI Target Portal. The Portal is either an IP or ip_addr:port if the port is other than default (typically TCP ports 860 and 3260).
#### name

###### Required •  TypeString

Volume's name. Must be a DNS_LABEL and unique within the pod. More info: https://kubernetes.io/docs/concepts/overview/working-with-objects/names/#names
## nfs

NFS represents an NFS mount on the host that shares a pod's lifetime More info: https://kubernetes.io/docs/concepts/storage/volumes#nfs

    
#### path

###### Required •  TypeString

Path that is exported by the NFS server. More info: https://kubernetes.io/docs/concepts/storage/volumes#nfs
#### read_only

######  TypeString

ReadOnly here will force the NFS export to be mounted with read-only permissions. Defaults to false. More info: https://kubernetes.io/docs/concepts/storage/volumes#nfs
#### server

###### Required •  TypeString

Server is the hostname or IP address of the NFS server. More info: https://kubernetes.io/docs/concepts/storage/volumes#nfs
## persistent_volume_claim

PersistentVolumeClaimVolumeSource represents a reference to a PersistentVolumeClaim in the same namespace. More info: https://kubernetes.io/docs/concepts/storage/persistent-volumes#persistentvolumeclaims

    
#### claim_name

###### Required •  TypeString

ClaimName is the name of a PersistentVolumeClaim in the same namespace as the pod using this volume. More info: https://kubernetes.io/docs/concepts/storage/persistent-volumes#persistentvolumeclaims
#### read_only

######  TypeString

Will force the ReadOnly setting in VolumeMounts. Default false.
## photon_persistent_disk

PhotonPersistentDisk represents a PhotonController persistent disk attached and mounted on kubelets host machine

    
#### fstype

######  TypeString

Filesystem type to mount. Must be a filesystem type supported by the host operating system. Ex. "ext4", "xfs", "ntfs". Implicitly inferred to be "ext4" if unspecified.
#### pdid

###### Required •  TypeString

ID that identifies Photon Controller persistent disk
## portworx_volume

PortworxVolume represents a portworx volume attached and mounted on kubelets host machine

    
#### fstype

######  TypeString

FSType represents the filesystem type to mount Must be a filesystem type supported by the host operating system. Ex. "ext4", "xfs". Implicitly inferred to be "ext4" if unspecified.
#### read_only

######  TypeString

Defaults to false (read/write). ReadOnly here will force the ReadOnly setting in VolumeMounts.
#### volume_id

###### Required •  TypeString

VolumeID uniquely identifies a Portworx volume
## projected

Items for all in one resources secrets, configmaps, and downward API

    
#### default_mode

######  TypeInt

Mode bits to use on created files by default. Must be a value between 0 and 0777. Directories within the path are not affected by this setting. This might be in conflict with other options that affect the file mode, like fsGroup, and the result can be other mode bits set.
## sources

list of volume projections

    
## config_map

information about the configMap data to project

    
## items

If unspecified, each key-value pair in the Data field of the referenced ConfigMap will be projected into the volume as a file whose name is the key and content is the value. If specified, the listed keys will be projected into the specified paths, and unlisted keys will not be present. If a key is specified which is not present in the ConfigMap, the volume setup will error unless it is marked optional. Paths must be relative and may not contain the '..' path or start with '..'.

    
#### key

###### Required •  TypeString

The key to project.
#### mode

######  TypeInt

Optional: mode bits to use on this file, must be a value between 0 and 0777. If not specified, the volume defaultMode will be used. This might be in conflict with other options that affect the file mode, like fsGroup, and the result can be other mode bits set.
#### path

###### Required •  TypeString

The relative path of the file to map the key to. May not be an absolute path. May not contain the path element '..'. May not start with the string '..'.
#### name

######  TypeString

Name of the referent. More info: https://kubernetes.io/docs/concepts/overview/working-with-objects/names/#names
#### optional

######  TypeString

Specify whether the ConfigMap or it's keys must be defined
## downward_api

information about the downwardAPI data to project

    
## items

Items is a list of DownwardAPIVolume file

    
## field_ref

Required: Selects a field of the pod: only annotations, labels, name and namespace are supported.

    
#### api_version

######  TypeString

Version of the schema the FieldPath is written in terms of, defaults to "v1".
#### field_path

###### Required •  TypeString

Path of the field to select in the specified API version.
#### mode

######  TypeInt

Optional: mode bits to use on this file, must be a value between 0 and 0777. If not specified, the volume defaultMode will be used. This might be in conflict with other options that affect the file mode, like fsGroup, and the result can be other mode bits set.
#### path

###### Required •  TypeString

Required: Path is  the relative path name of the file to be created. Must not be absolute or contain the '..' path. Must be utf-8 encoded. The first item of the relative path must not start with '..'
## resource_field_ref

Selects a resource of the container: only resources limits and requests (limits.cpu, limits.memory, requests.cpu and requests.memory) are currently supported.

    
#### container_name

######  TypeString

Container name: required for volumes, optional for env vars
#### divisor

######  TypeString

Specifies the output format of the exposed resources, defaults to "1"
#### resource

###### Required •  TypeString

Required: resource to select
## secret

information about the secret data to project

    
## items

If unspecified, each key-value pair in the Data field of the referenced Secret will be projected into the volume as a file whose name is the key and content is the value. If specified, the listed keys will be projected into the specified paths, and unlisted keys will not be present. If a key is specified which is not present in the Secret, the volume setup will error unless it is marked optional. Paths must be relative and may not contain the '..' path or start with '..'.

    
#### key

###### Required •  TypeString

The key to project.
#### mode

######  TypeInt

Optional: mode bits to use on this file, must be a value between 0 and 0777. If not specified, the volume defaultMode will be used. This might be in conflict with other options that affect the file mode, like fsGroup, and the result can be other mode bits set.
#### path

###### Required •  TypeString

The relative path of the file to map the key to. May not be an absolute path. May not contain the path element '..'. May not start with the string '..'.
#### name

######  TypeString

Name of the referent. More info: https://kubernetes.io/docs/concepts/overview/working-with-objects/names/#names
#### optional

######  TypeString

Specify whether the Secret or its key must be defined
## service_account_token

information about the serviceAccountToken data to project

    
#### audience

######  TypeString

Audience is the intended audience of the token. A recipient of a token must identify itself with an identifier specified in the audience of the token, and otherwise should reject the token. The audience defaults to the identifier of the apiserver.
#### expiration_seconds

######  TypeInt

ExpirationSeconds is the requested duration of validity of the service account token. As the token approaches expiration, the kubelet volume plugin will proactively rotate the service account token. The kubelet will start trying to rotate the token if the token is older than 80 percent of its time to live or if the token is older than 24 hours.Defaults to 1 hour and must be at least 10 minutes.
#### path

###### Required •  TypeString

Path is the path relative to the mount point of the file to project the token into.
## quobyte

Quobyte represents a Quobyte mount on the host that shares a pod's lifetime

    
#### group

######  TypeString

Group to map volume access to Default is no group
#### read_only

######  TypeString

ReadOnly here will force the Quobyte volume to be mounted with read-only permissions. Defaults to false.
#### registry

###### Required •  TypeString

Registry represents a single or multiple Quobyte Registry services specified as a string as host:port pair (multiple entries are separated with commas) which acts as the central registry for volumes
#### tenant

######  TypeString

Tenant owning the given Quobyte volume in the Backend Used with dynamically provisioned Quobyte volumes, value is set by the plugin
#### user

######  TypeString

User to map volume access to Defaults to serivceaccount user
#### volume

###### Required •  TypeString

Volume is a string that references an already created Quobyte volume by name.
## rbd

RBD represents a Rados Block Device mount on the host that shares a pod's lifetime. More info: https://releases.k8s.io/HEAD/examples/volumes/rbd/README.md

    
#### fstype

######  TypeString

Filesystem type of the volume that you want to mount. Tip: Ensure that the filesystem type is supported by the host operating system. Examples: "ext4", "xfs", "ntfs". Implicitly inferred to be "ext4" if unspecified. More info: https://kubernetes.io/docs/concepts/storage/volumes#rbd
#### image

###### Required •  TypeString

The rados image name. More info: https://releases.k8s.io/HEAD/examples/volumes/rbd/README.md#how-to-use-it
#### keyring

######  TypeString

Keyring is the path to key ring for RBDUser. Default is /etc/ceph/keyring. More info: https://releases.k8s.io/HEAD/examples/volumes/rbd/README.md#how-to-use-it
#### monitors

###### Required •  TypeList

A collection of Ceph monitors. More info: https://releases.k8s.io/HEAD/examples/volumes/rbd/README.md#how-to-use-it
#### pool

######  TypeString

The rados pool name. Default is rbd. More info: https://releases.k8s.io/HEAD/examples/volumes/rbd/README.md#how-to-use-it
#### read_only

######  TypeString

ReadOnly here will force the ReadOnly setting in VolumeMounts. Defaults to false. More info: https://releases.k8s.io/HEAD/examples/volumes/rbd/README.md#how-to-use-it
## secret_ref

SecretRef is name of the authentication secret for RBDUser. If provided overrides keyring. Default is nil. More info: https://releases.k8s.io/HEAD/examples/volumes/rbd/README.md#how-to-use-it

    
#### name

######  TypeString

Name of the referent. More info: https://kubernetes.io/docs/concepts/overview/working-with-objects/names/#names
#### user

######  TypeString

The rados user name. Default is admin. More info: https://releases.k8s.io/HEAD/examples/volumes/rbd/README.md#how-to-use-it
## scale_io

ScaleIO represents a ScaleIO persistent volume attached and mounted on Kubernetes nodes.

    
#### fstype

######  TypeString

Filesystem type to mount. Must be a filesystem type supported by the host operating system. Ex. "ext4", "xfs", "ntfs". Default is "xfs".
#### gateway

###### Required •  TypeString

The host address of the ScaleIO API Gateway.
#### protection_domain

######  TypeString

The name of the ScaleIO Protection Domain for the configured storage.
#### read_only

######  TypeString

Defaults to false (read/write). ReadOnly here will force the ReadOnly setting in VolumeMounts.
## secret_ref

SecretRef references to the secret for ScaleIO user and other sensitive information. If this is not provided, Login operation will fail.

    
#### name

######  TypeString

Name of the referent. More info: https://kubernetes.io/docs/concepts/overview/working-with-objects/names/#names
#### ssl_enabled

######  TypeString

Flag to enable/disable SSL communication with Gateway, default false
#### storage_mode

######  TypeString

Indicates whether the storage for a volume should be ThickProvisioned or ThinProvisioned. Default is ThinProvisioned.
#### storage_pool

######  TypeString

The ScaleIO Storage Pool associated with the protection domain.
#### system

###### Required •  TypeString

The name of the storage system as configured in ScaleIO.
#### volume_name

######  TypeString

The name of a volume already created in the ScaleIO system that is associated with this volume source.
## secret

Secret represents a secret that should populate this volume. More info: https://kubernetes.io/docs/concepts/storage/volumes#secret

    
#### default_mode

######  TypeInt

Optional: mode bits to use on created files by default. Must be a value between 0 and 0777. Defaults to 0644. Directories within the path are not affected by this setting. This might be in conflict with other options that affect the file mode, like fsGroup, and the result can be other mode bits set.
## items

If unspecified, each key-value pair in the Data field of the referenced Secret will be projected into the volume as a file whose name is the key and content is the value. If specified, the listed keys will be projected into the specified paths, and unlisted keys will not be present. If a key is specified which is not present in the Secret, the volume setup will error unless it is marked optional. Paths must be relative and may not contain the '..' path or start with '..'.

    
#### key

###### Required •  TypeString

The key to project.
#### mode

######  TypeInt

Optional: mode bits to use on this file, must be a value between 0 and 0777. If not specified, the volume defaultMode will be used. This might be in conflict with other options that affect the file mode, like fsGroup, and the result can be other mode bits set.
#### path

###### Required •  TypeString

The relative path of the file to map the key to. May not be an absolute path. May not contain the path element '..'. May not start with the string '..'.
#### optional

######  TypeString

Specify whether the Secret or it's keys must be defined
#### secret_name

######  TypeString

Name of the secret in the pod's namespace to use. More info: https://kubernetes.io/docs/concepts/storage/volumes#secret
## storageos

StorageOS represents a StorageOS volume attached and mounted on Kubernetes nodes.

    
#### fstype

######  TypeString

Filesystem type to mount. Must be a filesystem type supported by the host operating system. Ex. "ext4", "xfs", "ntfs". Implicitly inferred to be "ext4" if unspecified.
#### read_only

######  TypeString

Defaults to false (read/write). ReadOnly here will force the ReadOnly setting in VolumeMounts.
## secret_ref

SecretRef specifies the secret to use for obtaining the StorageOS API credentials.  If not specified, default values will be attempted.

    
#### name

######  TypeString

Name of the referent. More info: https://kubernetes.io/docs/concepts/overview/working-with-objects/names/#names
#### volume_name

######  TypeString

VolumeName is the human-readable name of the StorageOS volume.  Volume names are only unique within a namespace.
#### volume_namespace

######  TypeString

VolumeNamespace specifies the scope of the volume within StorageOS.  If no namespace is specified then the Pod's namespace will be used.  This allows the Kubernetes name scoping to be mirrored within StorageOS for tighter integration. Set VolumeName to any name to override the default behaviour. Set to "default" if you are not using namespaces within StorageOS. Namespaces that do not pre-exist within StorageOS will be created.
## vsphere_volume

VsphereVolume represents a vSphere volume attached and mounted on kubelets host machine

    
#### fstype

######  TypeString

Filesystem type to mount. Must be a filesystem type supported by the host operating system. Ex. "ext4", "xfs", "ntfs". Implicitly inferred to be "ext4" if unspecified.
#### storage_policy_id

######  TypeString

Storage Policy Based Management (SPBM) profile ID associated with the StoragePolicyName.
#### storage_policy_name

######  TypeString

Storage Policy Based Management (SPBM) profile name.
#### volume_path

###### Required •  TypeString

Path that identifies vSphere volume vmdk