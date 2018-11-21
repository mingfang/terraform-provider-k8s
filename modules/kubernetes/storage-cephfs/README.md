Create a set of PersistentVolumes and a coresponding set of PersistentVolumeClaims.

Useful for used with the VolumeClaimTemplates of StatefulSets.


## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| count | - | string | - | yes |
| monitors | - | list | - | yes |
| name | - | string | - | yes |
| secret\_name | - | string | - | yes |
| secret\_namespace | - | string | - | yes |
| storage | - | string | - | yes |
| user | - | string | - | yes |
| annotations | - | map | `{}` | no |
| mount\_options | - | list | `[]` | no |

## Outputs

| Name | Description |
|------|-------------|
| count | - |
| storage | - |
| storage\_class\_name | - |

