Runs a NFS Server serving from an empheral empty dir.

WARNING: For demonstration purpose only; You will loose data.

Based on https://github.com/kubernetes/examples/tree/master/staging/volumes/nfs

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| name | - | string | - | yes |
| image | - | string | `k8s.gcr.io/volume-nfs:0.8` | no |
| namespace | - | string | `default` | no |
| node\_selector | - | map | `{}` | no |
| replicas | - | string | `1` | no |

## Outputs

| Name | Description |
|------|-------------|
| cluster\_ip | - |
| deployment\_uid | - |
| name | - |

