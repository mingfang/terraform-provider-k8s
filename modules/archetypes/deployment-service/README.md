Documentation

terraform-docs --sort-inputs-by-required --with-aggregate-type-defaults md


## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| image | - | string | - | yes |
| name | - | string | - | yes |
| namespace | - | string | - | yes |
| port | - | string | - | yes |
| annotations | - | map | `{}` | no |
| node\_selector | - | map | `{}` | no |
| replicas | - | string | `1` | no |

## Outputs

| Name | Description |
|------|-------------|
| cluster\_ip | - |
| deployment\_uid | - |
| name | - |
| port | - |

