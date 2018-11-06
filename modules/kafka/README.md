## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| kafka\_zookeeper\_connect | - | string | - | yes |
| name | - | string | - | yes |
| storage | - | string | - | yes |
| storage\_class\_name | - | string | - | yes |
| image | - | string | `confluentinc/cp-kafka:5.0.0` | no |
| namespace | - | string | `default` | no |
| node\_selector | - | map | `{}` | no |
| replicas | - | string | `1` | no |
| volume\_claim\_template\_name | - | string | `pvc` | no |

## Outputs

| Name | Description |
|------|-------------|
| name | - |

