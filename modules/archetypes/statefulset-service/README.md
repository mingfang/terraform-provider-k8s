Documentation

terraform-docs --sort-inputs-by-required --with-aggregate-type-defaults md


## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| image | - | string | - | yes |
| name | - | string | - | yes |
| namespace | - | string | - | yes |
| port | - | string | - | yes |
| storage | - | string | - | yes |
| storage\_class\_name | - | string | - | yes |
| annotations | - | map | `{}` | no |
| node\_selector | - | map | `{}` | no |
| replicas | - | string | `1` | no |
| volume\_claim\_template\_name | - | string | `pvc` | no |

## Outputs

| Name | Description |
|------|-------------|
| cluster\_ip | - |
| name | - |
| port | - |
| statefulset\_uid | - |

