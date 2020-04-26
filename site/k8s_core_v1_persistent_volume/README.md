
# resource "k8s_core_v1_persistent_volume"

PersistentVolume (PV) is a storage resource provisioned by an administrator. It is analogous to a node. More info: https://kubernetes.io/docs/concepts/storage/persistent-volumes

  
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

    
- [access_modes](#access_modes)
- [capacity](#capacity)
- [mount_options](#mount_options)
- [persistent_volume_reclaim_policy](#persistent_volume_reclaim_policy)
- [storage_class_name](#storage_class_name)
- [volume_mode](#volume_mode)

    
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
- [secret_namespace](#secret_namespace)
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
- [namespace](#namespace)

    
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
- [namespace](#namespace)

    
</details>

</details>

<details>
<summary>claim_ref</summary><blockquote>

    
- [api_version](#api_version)
- [field_path](#field_path)
- [kind](#kind)
- [name](#name)
- [namespace](#namespace)
- [resource_version](#resource_version)
- [uid](#uid)

    
</details>

<details>
<summary>csi</summary><blockquote>

    
- [driver](#driver)*
- [fstype](#fstype)
- [read_only](#read_only)
- [volume_attributes](#volume_attributes)
- [volume_handle](#volume_handle)*

    
<details>
<summary>controller_expand_secret_ref</summary><blockquote>

    
- [name](#name)
- [namespace](#namespace)

    
</details>

<details>
<summary>controller_publish_secret_ref</summary><blockquote>

    
- [name](#name)
- [namespace](#namespace)

    
</details>

<details>
<summary>node_publish_secret_ref</summary><blockquote>

    
- [name](#name)
- [namespace](#namespace)

    
</details>

<details>
<summary>node_stage_secret_ref</summary><blockquote>

    
- [name](#name)
- [namespace](#namespace)

    
</details>

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
- [namespace](#namespace)

    
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
<summary>glusterfs</summary><blockquote>

    
- [endpoints](#endpoints)*
- [endpoints_namespace](#endpoints_namespace)
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
- [namespace](#namespace)

    
</details>

</details>

<details>
<summary>local</summary><blockquote>

    
- [fstype](#fstype)
- [path](#path)*

    
</details>

<details>
<summary>nfs</summary><blockquote>

    
- [path](#path)*
- [read_only](#read_only)
- [server](#server)*

    
</details>

<details>
<summary>node_affinity</summary><blockquote>

    

    
<details>
<summary>required</summary><blockquote>

    

    
<details>
<summary>node_selector_terms</summary><blockquote>

    

    
<details>
<summary>match_expressions</summary><blockquote>

    
- [key](#key)*
- [operator](#operator)*
- [values](#values)

    
</details>

<details>
<summary>match_fields</summary><blockquote>

    
- [key](#key)*
- [operator](#operator)*
- [values](#values)

    
</details>

</details>

</details>

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
- [namespace](#namespace)

    
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
- [namespace](#namespace)

    
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
<summary>vsphere_volume</summary><blockquote>

    
- [fstype](#fstype)
- [storage_policy_id](#storage_policy_id)
- [storage_policy_name](#storage_policy_name)
- [volume_path](#volume_path)*

    
</details>

</details>


<details>
<summary>example</summary><blockquote>

```hcl
resource "k8s_core_v1_persistent_volume" "this" {

  metadata {
    annotations = { "key" = "TypeString" }
    labels      = { "key" = "TypeString" }
    name        = "TypeString"
    namespace   = "TypeString"
  }

  spec {
    access_modes = ["TypeString"]

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
      read_only        = "TypeString"
      secret_name      = "TypeString*"
      secret_namespace = "TypeString"
      share_name       = "TypeString*"
    }
    capacity = { "key" = "TypeString" }

    cephfs {
      monitors    = ["TypeString*"]
      path        = "TypeString"
      read_only   = "TypeString"
      secret_file = "TypeString"

      secret_ref {
        name      = "TypeString"
        namespace = "TypeString"
      }
      user = "TypeString"
    }

    cinder {
      fstype    = "TypeString"
      read_only = "TypeString"

      secret_ref {
        name      = "TypeString"
        namespace = "TypeString"
      }
      volume_id = "TypeString*"
    }

    claim_ref {
      api_version      = "TypeString"
      field_path       = "TypeString"
      kind             = "TypeString"
      name             = "TypeString"
      namespace        = "TypeString"
      resource_version = "TypeString"
      uid              = "TypeString"
    }

    csi {

      controller_expand_secret_ref {
        name      = "TypeString"
        namespace = "TypeString"
      }

      controller_publish_secret_ref {
        name      = "TypeString"
        namespace = "TypeString"
      }
      driver = "TypeString*"
      fstype = "TypeString"

      node_publish_secret_ref {
        name      = "TypeString"
        namespace = "TypeString"
      }

      node_stage_secret_ref {
        name      = "TypeString"
        namespace = "TypeString"
      }
      read_only         = "TypeString"
      volume_attributes = { "key" = "TypeString" }
      volume_handle     = "TypeString*"
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
        name      = "TypeString"
        namespace = "TypeString"
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

    glusterfs {
      endpoints           = "TypeString*"
      endpoints_namespace = "TypeString"
      path                = "TypeString*"
      read_only           = "TypeString"
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
        name      = "TypeString"
        namespace = "TypeString"
      }
      target_portal = "TypeString*"
    }

    local {
      fstype = "TypeString"
      path   = "TypeString*"
    }
    mount_options = ["TypeString"]

    nfs {
      path      = "TypeString*"
      read_only = "TypeString"
      server    = "TypeString*"
    }

    node_affinity {

      required {

        node_selector_terms {

          match_expressions {
            key      = "TypeString*"
            operator = "TypeString*"
            values   = ["TypeString"]
          }

          match_fields {
            key      = "TypeString*"
            operator = "TypeString*"
            values   = ["TypeString"]
          }
        }
      }
    }
    persistent_volume_reclaim_policy = "TypeString"

    photon_persistent_disk {
      fstype = "TypeString"
      pdid   = "TypeString*"
    }

    portworx_volume {
      fstype    = "TypeString"
      read_only = "TypeString"
      volume_id = "TypeString*"
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
        name      = "TypeString"
        namespace = "TypeString"
      }
      user = "TypeString"
    }

    scale_io {
      fstype            = "TypeString"
      gateway           = "TypeString*"
      protection_domain = "TypeString"
      read_only         = "TypeString"

      secret_ref {
        name      = "TypeString"
        namespace = "TypeString"
      }
      ssl_enabled  = "TypeString"
      storage_mode = "TypeString"
      storage_pool = "TypeString"
      system       = "TypeString*"
      volume_name  = "TypeString"
    }
    storage_class_name = "TypeString"

    storageos {
      fstype    = "TypeString"
      read_only = "TypeString"

      secret_ref {
        api_version      = "TypeString"
        field_path       = "TypeString"
        kind             = "TypeString"
        name             = "TypeString"
        namespace        = "TypeString"
        resource_version = "TypeString"
        uid              = "TypeString"
      }
      volume_name      = "TypeString"
      volume_namespace = "TypeString"
    }
    volume_mode = "TypeString"

    vsphere_volume {
      fstype              = "TypeString"
      storage_policy_id   = "TypeString"
      storage_policy_name = "TypeString"
      volume_path         = "TypeString*"
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
## spec

Spec defines a specification of a persistent volume owned by the cluster. Provisioned by an administrator. More info: https://kubernetes.io/docs/concepts/storage/persistent-volumes#persistent-volumes

    
#### access_modes

######  TypeList

AccessModes contains all ways the volume can be mounted. More info: https://kubernetes.io/docs/concepts/storage/persistent-volumes#access-modes
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
#### secret_namespace

######  TypeString

the namespace of the secret that contains Azure Storage Account Name and Key default is the same as the Pod
#### share_name

###### Required •  TypeString

Share Name
#### capacity

######  TypeMap

A description of the persistent volume's resources and capacity. More info: https://kubernetes.io/docs/concepts/storage/persistent-volumes#capacity
## cephfs

CephFS represents a Ceph FS mount on the host that shares a pod's lifetime

    
#### monitors

###### Required •  TypeList

Required: Monitors is a collection of Ceph monitors More info: https://examples.k8s.io/volumes/cephfs/README.md#how-to-use-it
#### path

######  TypeString

Optional: Used as the mounted root, rather than the full Ceph tree, default is /
#### read_only

######  TypeString

Optional: Defaults to false (read/write). ReadOnly here will force the ReadOnly setting in VolumeMounts. More info: https://examples.k8s.io/volumes/cephfs/README.md#how-to-use-it
#### secret_file

######  TypeString

Optional: SecretFile is the path to key ring for User, default is /etc/ceph/user.secret More info: https://examples.k8s.io/volumes/cephfs/README.md#how-to-use-it
## secret_ref

Optional: SecretRef is reference to the authentication secret for User, default is empty. More info: https://examples.k8s.io/volumes/cephfs/README.md#how-to-use-it

    
#### name

######  TypeString

Name is unique within a namespace to reference a secret resource.
#### namespace

######  TypeString

Namespace defines the space within which the secret name must be unique.
#### user

######  TypeString

Optional: User is the rados user name, default is admin More info: https://examples.k8s.io/volumes/cephfs/README.md#how-to-use-it
## cinder

Cinder represents a cinder volume attached and mounted on kubelets host machine. More info: https://examples.k8s.io/mysql-cinder-pd/README.md

    
#### fstype

######  TypeString

Filesystem type to mount. Must be a filesystem type supported by the host operating system. Examples: "ext4", "xfs", "ntfs". Implicitly inferred to be "ext4" if unspecified. More info: https://examples.k8s.io/mysql-cinder-pd/README.md
#### read_only

######  TypeString

Optional: Defaults to false (read/write). ReadOnly here will force the ReadOnly setting in VolumeMounts. More info: https://examples.k8s.io/mysql-cinder-pd/README.md
## secret_ref

Optional: points to a secret object containing parameters used to connect to OpenStack.

    
#### name

######  TypeString

Name is unique within a namespace to reference a secret resource.
#### namespace

######  TypeString

Namespace defines the space within which the secret name must be unique.
#### volume_id

###### Required •  TypeString

volume id used to identify the volume in cinder. More info: https://examples.k8s.io/mysql-cinder-pd/README.md
## claim_ref

ClaimRef is part of a bi-directional binding between PersistentVolume and PersistentVolumeClaim. Expected to be non-nil when bound. claim.VolumeName is the authoritative bind between PV and PVC. More info: https://kubernetes.io/docs/concepts/storage/persistent-volumes#binding

    
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
## csi

CSI represents storage that is handled by an external CSI driver (Beta feature).

    
## controller_expand_secret_ref

ControllerExpandSecretRef is a reference to the secret object containing sensitive information to pass to the CSI driver to complete the CSI ControllerExpandVolume call. This is an alpha field and requires enabling ExpandCSIVolumes feature gate. This field is optional, and may be empty if no secret is required. If the secret object contains more than one secret, all secrets are passed.

    
#### name

######  TypeString

Name is unique within a namespace to reference a secret resource.
#### namespace

######  TypeString

Namespace defines the space within which the secret name must be unique.
## controller_publish_secret_ref

ControllerPublishSecretRef is a reference to the secret object containing sensitive information to pass to the CSI driver to complete the CSI ControllerPublishVolume and ControllerUnpublishVolume calls. This field is optional, and may be empty if no secret is required. If the secret object contains more than one secret, all secrets are passed.

    
#### name

######  TypeString

Name is unique within a namespace to reference a secret resource.
#### namespace

######  TypeString

Namespace defines the space within which the secret name must be unique.
#### driver

###### Required •  TypeString

Driver is the name of the driver to use for this volume. Required.
#### fstype

######  TypeString

Filesystem type to mount. Must be a filesystem type supported by the host operating system. Ex. "ext4", "xfs", "ntfs".
## node_publish_secret_ref

NodePublishSecretRef is a reference to the secret object containing sensitive information to pass to the CSI driver to complete the CSI NodePublishVolume and NodeUnpublishVolume calls. This field is optional, and may be empty if no secret is required. If the secret object contains more than one secret, all secrets are passed.

    
#### name

######  TypeString

Name is unique within a namespace to reference a secret resource.
#### namespace

######  TypeString

Namespace defines the space within which the secret name must be unique.
## node_stage_secret_ref

NodeStageSecretRef is a reference to the secret object containing sensitive information to pass to the CSI driver to complete the CSI NodeStageVolume and NodeStageVolume and NodeUnstageVolume calls. This field is optional, and may be empty if no secret is required. If the secret object contains more than one secret, all secrets are passed.

    
#### name

######  TypeString

Name is unique within a namespace to reference a secret resource.
#### namespace

######  TypeString

Namespace defines the space within which the secret name must be unique.
#### read_only

######  TypeString

Optional: The value to pass to ControllerPublishVolumeRequest. Defaults to false (read/write).
#### volume_attributes

######  TypeMap

Attributes of the volume to publish.
#### volume_handle

###### Required •  TypeString

VolumeHandle is the unique volume name returned by the CSI volume plugin’s CreateVolume to refer to the volume on all subsequent calls. Required.
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

Name is unique within a namespace to reference a secret resource.
#### namespace

######  TypeString

Namespace defines the space within which the secret name must be unique.
## flocker

Flocker represents a Flocker volume attached to a kubelet's host machine and exposed to the pod for its usage. This depends on the Flocker control service being running

    
#### dataset_name

######  TypeString

Name of the dataset stored as metadata -> name on the dataset for Flocker should be considered as deprecated
#### dataset_uuid

######  TypeString

UUID of the dataset. This is unique identifier of a Flocker dataset
## gce_persistent_disk

GCEPersistentDisk represents a GCE Disk resource that is attached to a kubelet's host machine and then exposed to the pod. Provisioned by an admin. More info: https://kubernetes.io/docs/concepts/storage/volumes#gcepersistentdisk

    
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
## glusterfs

Glusterfs represents a Glusterfs volume that is attached to a host and exposed to the pod. Provisioned by an admin. More info: https://examples.k8s.io/volumes/glusterfs/README.md

    
#### endpoints

###### Required •  TypeString

EndpointsName is the endpoint name that details Glusterfs topology. More info: https://examples.k8s.io/volumes/glusterfs/README.md#create-a-pod
#### endpoints_namespace

######  TypeString

EndpointsNamespace is the namespace that contains Glusterfs endpoint. If this field is empty, the EndpointNamespace defaults to the same namespace as the bound PVC. More info: https://examples.k8s.io/volumes/glusterfs/README.md#create-a-pod
#### path

###### Required •  TypeString

Path is the Glusterfs volume path. More info: https://examples.k8s.io/volumes/glusterfs/README.md#create-a-pod
#### read_only

######  TypeString

ReadOnly here will force the Glusterfs volume to be mounted with read-only permissions. Defaults to false. More info: https://examples.k8s.io/volumes/glusterfs/README.md#create-a-pod
## host_path

HostPath represents a directory on the host. Provisioned by a developer or tester. This is useful for single-node development and testing only! On-host storage is not supported in any way and WILL NOT WORK in a multi-node cluster. More info: https://kubernetes.io/docs/concepts/storage/volumes#hostpath

    
#### path

###### Required •  TypeString

Path of the directory on the host. If the path is a symlink, it will follow the link to the real path. More info: https://kubernetes.io/docs/concepts/storage/volumes#hostpath
#### type

######  TypeString

Type for HostPath Volume Defaults to "" More info: https://kubernetes.io/docs/concepts/storage/volumes#hostpath
## iscsi

ISCSI represents an ISCSI Disk resource that is attached to a kubelet's host machine and then exposed to the pod. Provisioned by an admin.

    
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

iSCSI Target Portal List. The Portal is either an IP or ip_addr:port if the port is other than default (typically TCP ports 860 and 3260).
#### read_only

######  TypeString

ReadOnly here will force the ReadOnly setting in VolumeMounts. Defaults to false.
## secret_ref

CHAP Secret for iSCSI target and initiator authentication

    
#### name

######  TypeString

Name is unique within a namespace to reference a secret resource.
#### namespace

######  TypeString

Namespace defines the space within which the secret name must be unique.
#### target_portal

###### Required •  TypeString

iSCSI Target Portal. The Portal is either an IP or ip_addr:port if the port is other than default (typically TCP ports 860 and 3260).
## local

Local represents directly-attached storage with node affinity

    
#### fstype

######  TypeString

Filesystem type to mount. It applies only when the Path is a block device. Must be a filesystem type supported by the host operating system. Ex. "ext4", "xfs", "ntfs". The default value is to auto-select a fileystem if unspecified.
#### path

###### Required •  TypeString

The full path to the volume on the node. It can be either a directory or block device (disk, partition, ...).
#### mount_options

######  TypeList

A list of mount options, e.g. ["ro", "soft"]. Not validated - mount will simply fail if one is invalid. More info: https://kubernetes.io/docs/concepts/storage/persistent-volumes/#mount-options
## nfs

NFS represents an NFS mount on the host. Provisioned by an admin. More info: https://kubernetes.io/docs/concepts/storage/volumes#nfs

    
#### path

###### Required •  TypeString

Path that is exported by the NFS server. More info: https://kubernetes.io/docs/concepts/storage/volumes#nfs
#### read_only

######  TypeString

ReadOnly here will force the NFS export to be mounted with read-only permissions. Defaults to false. More info: https://kubernetes.io/docs/concepts/storage/volumes#nfs
#### server

###### Required •  TypeString

Server is the hostname or IP address of the NFS server. More info: https://kubernetes.io/docs/concepts/storage/volumes#nfs
## node_affinity

NodeAffinity defines constraints that limit what nodes this volume can be accessed from. This field influences the scheduling of pods that use this volume.

    
## required

Required specifies hard node constraints that must be met.

    
## node_selector_terms

Required. A list of node selector terms. The terms are ORed.

    
## match_expressions

A list of node selector requirements by node's labels.

    
#### key

###### Required •  TypeString

The label key that the selector applies to.
#### operator

###### Required •  TypeString

Represents a key's relationship to a set of values. Valid operators are In, NotIn, Exists, DoesNotExist. Gt, and Lt.
#### values

######  TypeList

An array of string values. If the operator is In or NotIn, the values array must be non-empty. If the operator is Exists or DoesNotExist, the values array must be empty. If the operator is Gt or Lt, the values array must have a single element, which will be interpreted as an integer. This array is replaced during a strategic merge patch.
## match_fields

A list of node selector requirements by node's fields.

    
#### key

###### Required •  TypeString

The label key that the selector applies to.
#### operator

###### Required •  TypeString

Represents a key's relationship to a set of values. Valid operators are In, NotIn, Exists, DoesNotExist. Gt, and Lt.
#### values

######  TypeList

An array of string values. If the operator is In or NotIn, the values array must be non-empty. If the operator is Exists or DoesNotExist, the values array must be empty. If the operator is Gt or Lt, the values array must have a single element, which will be interpreted as an integer. This array is replaced during a strategic merge patch.
#### persistent_volume_reclaim_policy

######  TypeString

What happens to a persistent volume when released from its claim. Valid options are Retain (default for manually created PersistentVolumes), Delete (default for dynamically provisioned PersistentVolumes), and Recycle (deprecated). Recycle must be supported by the volume plugin underlying this PersistentVolume. More info: https://kubernetes.io/docs/concepts/storage/persistent-volumes#reclaiming
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

RBD represents a Rados Block Device mount on the host that shares a pod's lifetime. More info: https://examples.k8s.io/volumes/rbd/README.md

    
#### fstype

######  TypeString

Filesystem type of the volume that you want to mount. Tip: Ensure that the filesystem type is supported by the host operating system. Examples: "ext4", "xfs", "ntfs". Implicitly inferred to be "ext4" if unspecified. More info: https://kubernetes.io/docs/concepts/storage/volumes#rbd
#### image

###### Required •  TypeString

The rados image name. More info: https://examples.k8s.io/volumes/rbd/README.md#how-to-use-it
#### keyring

######  TypeString

Keyring is the path to key ring for RBDUser. Default is /etc/ceph/keyring. More info: https://examples.k8s.io/volumes/rbd/README.md#how-to-use-it
#### monitors

###### Required •  TypeList

A collection of Ceph monitors. More info: https://examples.k8s.io/volumes/rbd/README.md#how-to-use-it
#### pool

######  TypeString

The rados pool name. Default is rbd. More info: https://examples.k8s.io/volumes/rbd/README.md#how-to-use-it
#### read_only

######  TypeString

ReadOnly here will force the ReadOnly setting in VolumeMounts. Defaults to false. More info: https://examples.k8s.io/volumes/rbd/README.md#how-to-use-it
## secret_ref

SecretRef is name of the authentication secret for RBDUser. If provided overrides keyring. Default is nil. More info: https://examples.k8s.io/volumes/rbd/README.md#how-to-use-it

    
#### name

######  TypeString

Name is unique within a namespace to reference a secret resource.
#### namespace

######  TypeString

Namespace defines the space within which the secret name must be unique.
#### user

######  TypeString

The rados user name. Default is admin. More info: https://examples.k8s.io/volumes/rbd/README.md#how-to-use-it
## scale_io

ScaleIO represents a ScaleIO persistent volume attached and mounted on Kubernetes nodes.

    
#### fstype

######  TypeString

Filesystem type to mount. Must be a filesystem type supported by the host operating system. Ex. "ext4", "xfs", "ntfs". Default is "xfs"
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

Name is unique within a namespace to reference a secret resource.
#### namespace

######  TypeString

Namespace defines the space within which the secret name must be unique.
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
#### storage_class_name

######  TypeString

Name of StorageClass to which this persistent volume belongs. Empty value means that this volume does not belong to any StorageClass.
## storageos

StorageOS represents a StorageOS volume that is attached to the kubelet's host machine and mounted into the pod More info: https://examples.k8s.io/volumes/storageos/README.md

    
#### fstype

######  TypeString

Filesystem type to mount. Must be a filesystem type supported by the host operating system. Ex. "ext4", "xfs", "ntfs". Implicitly inferred to be "ext4" if unspecified.
#### read_only

######  TypeString

Defaults to false (read/write). ReadOnly here will force the ReadOnly setting in VolumeMounts.
## secret_ref

SecretRef specifies the secret to use for obtaining the StorageOS API credentials.  If not specified, default values will be attempted.

    
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
#### volume_name

######  TypeString

VolumeName is the human-readable name of the StorageOS volume.  Volume names are only unique within a namespace.
#### volume_namespace

######  TypeString

VolumeNamespace specifies the scope of the volume within StorageOS.  If no namespace is specified then the Pod's namespace will be used.  This allows the Kubernetes name scoping to be mirrored within StorageOS for tighter integration. Set VolumeName to any name to override the default behaviour. Set to "default" if you are not using namespaces within StorageOS. Namespaces that do not pre-exist within StorageOS will be created.
#### volume_mode

######  TypeString

volumeMode defines if a volume is intended to be used with a formatted filesystem or to remain in raw block state. Value of Filesystem is implied when not included in spec.
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