Documentation

[Kubernetes Discovery](https://raw.githubusercontent.com/prometheus/prometheus/release-2.5/documentation/examples/prometheus-kubernetes.yml)


## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| storage | - | string | - | yes |
| storage\_class\_name | - | string | - | yes |
| annotations | - | map | `{}` | no |
| dns\_policy | - | string | `` | no |
| image | - | string | `prom/prometheus` | no |
| name | - | string | `prometheus` | no |
| namespace | - | string | `default` | no |
| node\_selector | - | map | `{}` | no |
| port | - | string | `9090` | no |
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

