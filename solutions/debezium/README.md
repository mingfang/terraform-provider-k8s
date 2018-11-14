## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| kafka\_count | - | string | - | yes |
| kafka\_storage | - | string | - | yes |
| kafka\_storage\_class | - | string | - | yes |
| name | - | string | - | yes |
| zookeeper\_count | - | string | - | yes |
| zookeeper\_storage | - | string | - | yes |
| zookeeper\_storage\_class | - | string | - | yes |
| debezium-version | - | string | `0.9` | no |

## Outputs

| Name | Description |
|------|-------------|
| kafka-bootstrap-servers | - |
| kafka-connect-sink | - |
| kafka-connect-source | - |

