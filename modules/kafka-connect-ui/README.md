## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| kafka\_connect | - | string | - | yes |
| name | - | string | - | yes |
| annotations | - | map | `{}` | no |
| image | - | string | `landoop/kafka-connect-ui` | no |
| namespace | - | string | `default` | no |
| node\_selector | - | map | `{}` | no |
| replicas | - | string | `1` | no |

## Outputs

| Name | Description |
|------|-------------|
| name | - |

