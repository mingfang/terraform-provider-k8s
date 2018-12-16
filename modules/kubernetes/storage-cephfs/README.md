Create a set of PersistentVolumes and a coresponding set of PersistentVolumeClaims.

Useful for used with the VolumeClaimTemplates of StatefulSets.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| count |  | string | n/a | yes |
| monitors |  | list | n/a | yes |
| name |  | string | n/a | yes |
| secret\_name |  | string | n/a | yes |
| secret\_namespace |  | string | n/a | yes |
| storage |  | string | n/a | yes |
| user |  | string | n/a | yes |
| annotations |  | map | `{}` | no |
| mount\_options |  | list | `[]` | no |
| path |  | string | `"/"` | no |

## Outputs

| Name | Description |
|------|-------------|
| count |  |
| storage |  |
| storage\_class\_name |  |

<img src="diagram.svg"/>
