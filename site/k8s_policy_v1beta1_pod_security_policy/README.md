
# resource "k8s_policy_v1beta1_pod_security_policy"

PodSecurityPolicy governs the ability to make requests that affect the Security Context that will be applied to a pod and container.

  
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

    
</details>

<details>
<summary>spec</summary><blockquote>

    
- [allow_privilege_escalation](#allow_privilege_escalation)
- [allowed_capabilities](#allowed_capabilities)
- [allowed_proc_mount_types](#allowed_proc_mount_types)
- [allowed_unsafe_sysctls](#allowed_unsafe_sysctls)
- [default_add_capabilities](#default_add_capabilities)
- [default_allow_privilege_escalation](#default_allow_privilege_escalation)
- [forbidden_sysctls](#forbidden_sysctls)
- [host_ipc](#host_ipc)
- [host_network](#host_network)
- [host_pid](#host_pid)
- [privileged](#privileged)
- [read_only_root_filesystem](#read_only_root_filesystem)
- [required_drop_capabilities](#required_drop_capabilities)
- [volumes](#volumes)

    
<details>
<summary>allowed_csi_drivers</summary><blockquote>

    
- [name](#name)*

    
</details>

<details>
<summary>allowed_flex_volumes</summary><blockquote>

    
- [driver](#driver)*

    
</details>

<details>
<summary>allowed_host_paths</summary><blockquote>

    
- [path_prefix](#path_prefix)
- [read_only](#read_only)

    
</details>

<details>
<summary>fsgroup</summary><blockquote>

    
- [rule](#rule)

    
<details>
<summary>ranges</summary><blockquote>

    
- [max](#max)*
- [min](#min)*

    
</details>

</details>

<details>
<summary>host_ports</summary><blockquote>

    
- [max](#max)*
- [min](#min)*

    
</details>

<details>
<summary>run_asgroup</summary><blockquote>

    
- [rule](#rule)*

    
<details>
<summary>ranges</summary><blockquote>

    
- [max](#max)*
- [min](#min)*

    
</details>

</details>

<details>
<summary>run_asuser</summary><blockquote>

    
- [rule](#rule)*

    
<details>
<summary>ranges</summary><blockquote>

    
- [max](#max)*
- [min](#min)*

    
</details>

</details>

<details>
<summary>selinux</summary><blockquote>

    
- [rule](#rule)*

    
<details>
<summary>selinux_options</summary><blockquote>

    
- [level](#level)
- [role](#role)
- [type](#type)
- [user](#user)

    
</details>

</details>

<details>
<summary>supplemental_groups</summary><blockquote>

    
- [rule](#rule)

    
<details>
<summary>ranges</summary><blockquote>

    
- [max](#max)*
- [min](#min)*

    
</details>

</details>

</details>


<details>
<summary>example</summary><blockquote>

```hcl
resource "k8s_policy_v1beta1_pod_security_policy" "this" {

  metadata {
    annotations = { "key" = "TypeString" }
    labels      = { "key" = "TypeString" }
    name        = "TypeString"
    namespace   = "TypeString"
  }

  spec {
    allow_privilege_escalation = "TypeBool"
    allowed_capabilities       = ["TypeString"]

    allowed_csi_drivers {
      name = "TypeString*"
    }

    allowed_flex_volumes {
      driver = "TypeString*"
    }

    allowed_host_paths {
      path_prefix = "TypeString"
      read_only   = "TypeBool"
    }
    allowed_proc_mount_types           = ["TypeString"]
    allowed_unsafe_sysctls             = ["TypeString"]
    default_add_capabilities           = ["TypeString"]
    default_allow_privilege_escalation = "TypeBool"
    forbidden_sysctls                  = ["TypeString"]

    fsgroup {

      ranges {
        max = "TypeInt*"
        min = "TypeInt*"
      }
      rule = "TypeString"
    }
    host_ipc     = "TypeBool"
    host_network = "TypeBool"
    host_pid     = "TypeBool"

    host_ports {
      max = "TypeInt*"
      min = "TypeInt*"
    }
    privileged                 = "TypeBool"
    read_only_root_filesystem  = "TypeBool"
    required_drop_capabilities = ["TypeString"]

    run_asgroup {

      ranges {
        max = "TypeInt*"
        min = "TypeInt*"
      }
      rule = "TypeString*"
    }

    run_asuser {

      ranges {
        max = "TypeInt*"
        min = "TypeInt*"
      }
      rule = "TypeString*"
    }

    selinux {
      rule = "TypeString*"

      selinux_options {
        level = "TypeString"
        role  = "TypeString"
        type  = "TypeString"
        user  = "TypeString"
      }
    }

    supplemental_groups {

      ranges {
        max = "TypeInt*"
        min = "TypeInt*"
      }
      rule = "TypeString"
    }
    volumes = ["TypeString"]
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
#### self_link

######  ReadOnly • TypeString

SelfLink is a URL representing this object. Populated by the system. Read-only.
#### uid

######  ReadOnly • TypeString

UID is the unique in time and space value for this object. It is typically generated by the server on successful creation of a resource and is not allowed to change on PUT operations.

Populated by the system. Read-only. More info: http://kubernetes.io/docs/user-guide/identifiers#uids
## spec

spec defines the policy enforced.

    
#### allow_privilege_escalation

######  TypeBool

allowPrivilegeEscalation determines if a pod can request to allow privilege escalation. If unspecified, defaults to true.
#### allowed_capabilities

######  TypeList

allowedCapabilities is a list of capabilities that can be requested to add to the container. Capabilities in this field may be added at the pod author's discretion. You must not list a capability in both allowedCapabilities and requiredDropCapabilities.
## allowed_csi_drivers

AllowedCSIDrivers is a whitelist of inline CSI drivers that must be explicitly set to be embedded within a pod spec. An empty value means no CSI drivers can run inline within a pod spec.

    
#### name

###### Required •  TypeString

Name is the registered name of the CSI driver
## allowed_flex_volumes

allowedFlexVolumes is a whitelist of allowed Flexvolumes.  Empty or nil indicates that all Flexvolumes may be used.  This parameter is effective only when the usage of the Flexvolumes is allowed in the "volumes" field.

    
#### driver

###### Required •  TypeString

driver is the name of the Flexvolume driver.
## allowed_host_paths

allowedHostPaths is a white list of allowed host paths. Empty indicates that all host paths may be used.

    
#### path_prefix

######  TypeString

pathPrefix is the path prefix that the host volume must match. It does not support `*`. Trailing slashes are trimmed when validating the path prefix with a host path.

Examples: `/foo` would allow `/foo`, `/foo/` and `/foo/bar` `/foo` would not allow `/food` or `/etc/foo`
#### read_only

######  TypeBool

when set to true, will allow host volumes matching the pathPrefix only if all volume mounts are readOnly.
#### allowed_proc_mount_types

######  TypeList

AllowedProcMountTypes is a whitelist of allowed ProcMountTypes. Empty or nil indicates that only the DefaultProcMountType may be used. This requires the ProcMountType feature flag to be enabled.
#### allowed_unsafe_sysctls

######  TypeList

allowedUnsafeSysctls is a list of explicitly allowed unsafe sysctls, defaults to none. Each entry is either a plain sysctl name or ends in "*" in which case it is considered as a prefix of allowed sysctls. Single * means all unsafe sysctls are allowed. Kubelet has to whitelist all allowed unsafe sysctls explicitly to avoid rejection.

Examples: e.g. "foo/*" allows "foo/bar", "foo/baz", etc. e.g. "foo.*" allows "foo.bar", "foo.baz", etc.
#### default_add_capabilities

######  TypeList

defaultAddCapabilities is the default set of capabilities that will be added to the container unless the pod spec specifically drops the capability.  You may not list a capability in both defaultAddCapabilities and requiredDropCapabilities. Capabilities added here are implicitly allowed, and need not be included in the allowedCapabilities list.
#### default_allow_privilege_escalation

######  TypeBool

defaultAllowPrivilegeEscalation controls the default setting for whether a process can gain more privileges than its parent process.
#### forbidden_sysctls

######  TypeList

forbiddenSysctls is a list of explicitly forbidden sysctls, defaults to none. Each entry is either a plain sysctl name or ends in "*" in which case it is considered as a prefix of forbidden sysctls. Single * means all sysctls are forbidden.

Examples: e.g. "foo/*" forbids "foo/bar", "foo/baz", etc. e.g. "foo.*" forbids "foo.bar", "foo.baz", etc.
## fsgroup

fsGroup is the strategy that will dictate what fs group is used by the SecurityContext.

    
## ranges

ranges are the allowed ranges of fs groups.  If you would like to force a single fs group then supply a single range with the same start and end. Required for MustRunAs.

    
#### max

###### Required •  TypeInt

max is the end of the range, inclusive.
#### min

###### Required •  TypeInt

min is the start of the range, inclusive.
#### rule

######  TypeString

rule is the strategy that will dictate what FSGroup is used in the SecurityContext.
#### host_ipc

######  TypeBool

hostIPC determines if the policy allows the use of HostIPC in the pod spec.
#### host_network

######  TypeBool

hostNetwork determines if the policy allows the use of HostNetwork in the pod spec.
#### host_pid

######  TypeBool

hostPID determines if the policy allows the use of HostPID in the pod spec.
## host_ports

hostPorts determines which host port ranges are allowed to be exposed.

    
#### max

###### Required •  TypeInt

max is the end of the range, inclusive.
#### min

###### Required •  TypeInt

min is the start of the range, inclusive.
#### privileged

######  TypeBool

privileged determines if a pod can request to be run as privileged.
#### read_only_root_filesystem

######  TypeBool

readOnlyRootFilesystem when set to true will force containers to run with a read only root file system.  If the container specifically requests to run with a non-read only root file system the PSP should deny the pod. If set to false the container may run with a read only root file system if it wishes but it will not be forced to.
#### required_drop_capabilities

######  TypeList

requiredDropCapabilities are the capabilities that will be dropped from the container.  These are required to be dropped and cannot be added.
## run_asgroup

RunAsGroup is the strategy that will dictate the allowable RunAsGroup values that may be set. If this field is omitted, the pod's RunAsGroup can take any value. This field requires the RunAsGroup feature gate to be enabled.

    
## ranges

ranges are the allowed ranges of gids that may be used. If you would like to force a single gid then supply a single range with the same start and end. Required for MustRunAs.

    
#### max

###### Required •  TypeInt

max is the end of the range, inclusive.
#### min

###### Required •  TypeInt

min is the start of the range, inclusive.
#### rule

###### Required •  TypeString

rule is the strategy that will dictate the allowable RunAsGroup values that may be set.
## run_asuser

runAsUser is the strategy that will dictate the allowable RunAsUser values that may be set.

    
## ranges

ranges are the allowed ranges of uids that may be used. If you would like to force a single uid then supply a single range with the same start and end. Required for MustRunAs.

    
#### max

###### Required •  TypeInt

max is the end of the range, inclusive.
#### min

###### Required •  TypeInt

min is the start of the range, inclusive.
#### rule

###### Required •  TypeString

rule is the strategy that will dictate the allowable RunAsUser values that may be set.
## selinux

seLinux is the strategy that will dictate the allowable labels that may be set.

    
#### rule

###### Required •  TypeString

rule is the strategy that will dictate the allowable labels that may be set.
## selinux_options

seLinuxOptions required to run as; required for MustRunAs More info: https://kubernetes.io/docs/tasks/configure-pod-container/security-context/

    
#### level

######  TypeString

Level is SELinux level label that applies to the container.
#### role

######  TypeString

Role is a SELinux role label that applies to the container.
#### type

######  TypeString

Type is a SELinux type label that applies to the container.
#### user

######  TypeString

User is a SELinux user label that applies to the container.
## supplemental_groups

supplementalGroups is the strategy that will dictate what supplemental groups are used by the SecurityContext.

    
## ranges

ranges are the allowed ranges of supplemental groups.  If you would like to force a single supplemental group then supply a single range with the same start and end. Required for MustRunAs.

    
#### max

###### Required •  TypeInt

max is the end of the range, inclusive.
#### min

###### Required •  TypeInt

min is the start of the range, inclusive.
#### rule

######  TypeString

rule is the strategy that will dictate what supplemental groups is used in the SecurityContext.
#### volumes

######  TypeList

volumes is a white list of allowed volume plugins. Empty indicates that no volumes may be used. To allow all volumes you may use '*'.