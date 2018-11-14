## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| mysql\_database | - | string | - | yes |
| mysql\_password | - | string | - | yes |
| mysql\_root\_password | - | string | - | yes |
| mysql\_user | - | string | - | yes |
| name | - | string | - | yes |
| storage | - | string | - | yes |
| storage\_class\_name | - | string | - | yes |
| image | - | string | `mysql` | no |
| namespace | - | string | `default` | no |
| node\_selector | - | map | `{}` | no |
| port | - | string | `3306` | no |
| replicas | - | string | `1` | no |
| volume\_claim\_template\_name | - | string | `pvc` | no |

## Outputs

| Name | Description |
|------|-------------|
| name | - |
| port | - |

