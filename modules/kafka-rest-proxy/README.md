<img src="diagram.svg"/>To view the full size interactive diagram, append ```?sanitize=true``` to the raw URL.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| name |  | string | n/a | yes |
| zookeeper |  | string | n/a | yes |
| image |  | string | `"confluentinc/cp-kafka-rest"` | no |
| namespace |  | string | `"default"` | no |
| node\_selector |  | map | `{}` | no |
| replicas |  | string | `"1"` | no |

## Outputs

| Name | Description |
|------|-------------|
| name |  |

