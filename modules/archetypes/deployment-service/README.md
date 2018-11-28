Documentation

terraform-docs --sort-inputs-by-required --with-aggregate-type-defaults md


## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| image | - | string | - | yes |
| name | - | string | - | yes |
| port | - | string | - | yes |
| annotations | - | map | `{}` | no |
| dns\_policy | - | string | `` | no |
| namespace | - | string | `` | no |
| node\_selector | - | map | `{}` | no |
| priority\_class\_name | - | string | `` | no |
| replicas | - | string | `1` | no |
| restart\_policy | - | string | `` | no |
| scheduler\_name | - | string | `` | no |
| service\_account\_name | - | string | `` | no |
| service\_type | - | string | `` | no |
| session\_affinity | - | string | `` | no |
| termination\_grace\_period\_seconds | - | string | `30` | no |

## Outputs

| Name | Description |
|------|-------------|
| cluster\_ip | - |
| deployment\_uid | - |
| name | - |
| port | - |

