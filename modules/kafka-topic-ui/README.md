## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| kafka\_rest\_proxy |  | string | n/a | yes |
| name |  | string | n/a | yes |
| annotations |  | map | `{}` | no |
| image |  | string | `"landoop/kafka-topics-ui"` | no |
| namespace |  | string | `"default"` | no |
| node\_selector |  | map | `{}` | no |
| replicas |  | string | `"1"` | no |

## Outputs

| Name | Description |
|------|-------------|
| name |  |

<img src="diagram.svg"/>
