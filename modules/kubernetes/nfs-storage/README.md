Create a set of PersistentVolumes and a coresponding set of PersistentVolumeClaims.

Useful for used with the VolumeClaimTemplates of StatefulSets.


## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| count | - | string | - | yes |
| name | - | string | - | yes |
| nfs\_server | - | string | - | yes |
| storage | - | string | - | yes |
| annotations | - | map | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| count | - |
| storage | - |
| storage\_class\_name | - |

