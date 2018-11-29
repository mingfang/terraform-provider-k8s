Documentation

terraform-docs --sort-inputs-by-required --with-aggregate-type-defaults md


## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| image | - | string | - | yes |
| name | - | string | - | yes |
| port | - | string | - | yes |
| storage | - | string | - | yes |
| storage\_class\_name | - | string | - | yes |
| annotations | - | map | `{}` | no |
| dns\_policy | - | string | `` | no |
| namespace | - | string | `` | no |
| node\_selector | - | map | `{}` | no |
| priority\_class\_name | - | string | `` | no |
| replicas | - | string | `1` | no |
| restart\_policy | - | string | `` | no |
| scheduler\_name | - | string | `` | no |
| service\_type | - | string | `` | no |
| session\_affinity | - | string | `` | no |
| termination\_grace\_period\_seconds | - | string | `30` | no |
| volume\_claim\_template\_name | - | string | `pvc` | no |

## Outputs

| Name | Description |
|------|-------------|
| cluster\_ip | - |
| name | - |
| port | - |
| statefulset\_uid | - |

