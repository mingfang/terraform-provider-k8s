Documentation

terraform-docs --sort-inputs-by-required --with-aggregate-type-defaults md


## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| gitlab\_url | - | string | - | yes |
| name | - | string | - | yes |
| registration\_token | - | string | - | yes |
| annotations | - | map | `{}` | no |
| image | - | string | `gitlab/gitlab-runner:latest` | no |
| namespace | - | string | `` | no |
| node\_selector | - | map | `{}` | no |
| port | - | string | `80` | no |
| replicas | - | string | `1` | no |

## Outputs

| Name | Description |
|------|-------------|
| cluster\_ip | - |
| deployment\_uid | - |
| name | - |
| port | - |

