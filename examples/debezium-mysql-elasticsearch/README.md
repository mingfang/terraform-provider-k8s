Use Debezium and Kafka Connect to sync from Mysql to Elasticsearch.

Based on https://github.com/debezium/debezium-examples/tree/master/unwrap-smt

Requirements: You must change the storage module to match your environment

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| name | - | string | `debezium-mysql-es` | no |
| topics | - | string | `customers` | no |

