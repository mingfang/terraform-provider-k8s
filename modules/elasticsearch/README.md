## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| name | - | string | `elasticsearch` | no |
| namespace | - | string | `default` | no |
| replicas | - | string | `2` | no |
| image | - | string | `docker.elastic.co/elasticsearch/elasticsearch:6.4.2` | no |
| heap\_size | - | string | `4g` | no |
| node\_selector | - | map | `<map>` | no |
| storage\_class\_name | - | string | - | yes |
| storage | - | string | - | yes |

