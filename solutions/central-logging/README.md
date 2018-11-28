Central Logging Solution using Elasticsearch, Fluentbit, and Kibana

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| es\_replicas | - | string | - | yes |
| name | - | string | - | yes |
| storage | - | string | - | yes |
| storage\_class\_name | - | string | - | yes |
| namespace | - | string | `default` | no |

## Outputs

| Name | Description |
|------|-------------|
| elasticsearch\_name | - |
| elasticsearch\_port | - |
| kibana\_name | - |
| kibana\_port | - |

