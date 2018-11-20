Documentation

terraform-docs --sort-inputs-by-required --with-aggregate-type-defaults md


## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| auto\_devops\_domain | - | string | - | yes |
| gitlab\_external\_url | - | string | - | yes |
| gitlab\_root\_password | - | string | - | yes |
| gitlab\_runners\_registration\_token | - | string | - | yes |
| mattermost\_external\_url | - | string | - | yes |
| name | - | string | - | yes |
| registry\_external\_url | - | string | - | yes |
| storage | - | string | - | yes |
| storage\_class\_name | - | string | - | yes |
| annotations | - | map | `{}` | no |
| image | - | string | `gitlab/gitlab-ee:latest` | no |
| namespace | - | string | `` | no |
| node\_selector | - | map | `{}` | no |
| port | - | string | `80` | no |
| replicas | - | string | `1` | no |
| volume\_claim\_template\_name | - | string | `pvc` | no |

## Outputs

| Name | Description |
|------|-------------|
| cluster\_ip | - |
| name | - |
| port | - |
| statefulset\_uid | - |

