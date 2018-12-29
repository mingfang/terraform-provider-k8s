<img src="diagram.svg"/>To view the full size interactive diagram, append ```?sanitize=true``` to the raw URL.

Central Logging Solution using Elasticsearch, Fluentbit, and Kibana

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| es\_replicas |  | string | n/a | yes |
| name |  | string | n/a | yes |
| storage |  | string | n/a | yes |
| storage\_class\_name |  | string | n/a | yes |
| namespace |  | string | `"default"` | no |

## Outputs

| Name | Description |
|------|-------------|
| elasticsearch\_name |  |
| elasticsearch\_port |  |
| kibana\_name |  |
| kibana\_port |  |

