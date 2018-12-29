<img src="diagram.svg"/>To view the full size interactive diagram, append ```?sanitize=true``` to the raw URL.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| name |  | string | n/a | yes |
| annotations |  | map | `{}` | no |
| image | this image contains example data | string | `"debezium/example-mysql"` | no |
| mysql\_database |  | string | `""` | no |
| mysql\_password |  | string | `"mysqlpw"` | no |
| mysql\_root\_password |  | string | `"debezium"` | no |
| mysql\_user |  | string | `"mysqluser"` | no |
| namespace |  | string | `""` | no |
| node\_selector |  | map | `{}` | no |
| port |  | string | `"3306"` | no |
| replicas |  | string | `"1"` | no |

## Outputs

| Name | Description |
|------|-------------|
| cluster\_ip |  |
| name |  |
| port |  |
| statefulset\_uid |  |

