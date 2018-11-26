[Fluent Bit](https://fluentbit.io)

FluentBit Runs as a daemonset sending logs directly to Elasticsearch

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| fluent\_elasticsearch\_host | - | string | - | yes |
| fluent\_elasticsearch\_port | - | string | - | yes |
| name | - | string | - | yes |
| annotations | - | map | `{}` | no |
| dns\_policy | - | string | `` | no |
| image | - | string | `fluent/fluent-bit:0.14.8` | no |
| namespace | - | string | `` | no |
| node\_selector | - | map | `{}` | no |
| priority\_class\_name | - | string | `` | no |
| replicas | - | string | `1` | no |
| restart\_policy | - | string | `` | no |
| scheduler\_name | - | string | `` | no |
| service\_account\_name | - | string | `` | no |
| termination\_grace\_period\_seconds | - | string | `30` | no |

## Outputs

| Name | Description |
|------|-------------|
| name | - |

