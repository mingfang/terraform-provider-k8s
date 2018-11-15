Based on https://github.com/kubernetes/ingress-nginx/blob/master/deploy/mandatory.yaml

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| image | - | string | `quay.io/kubernetes-ingress-controller/nginx-ingress-controller:0.20.0` | no |
| name | - | string | `ingress-nginx` | no |
| namespace | - | string | `ingress-nginx` | no |
| node\_port\_http | - | string | `30000` | no |
| node\_port\_https | - | string | `30443` | no |
| node\_selector | - | map | `{}` | no |
| replicas | - | string | `1` | no |

