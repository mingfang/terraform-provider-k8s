## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| kafka\_rest\_proxy | - | string | - | yes |
| name | - | string | - | yes |
| annotations | - | map | `{}` | no |
| image | - | string | `landoop/kafka-topics-ui` | no |
| namespace | - | string | `default` | no |
| node\_selector | - | map | `{}` | no |
| replicas | - | string | `1` | no |

## Outputs

| Name | Description |
|------|-------------|
| name | - |

