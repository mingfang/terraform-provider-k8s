variable "name" {}

variable "kafka_connect" {}

variable "connector_name" {}

variable "connector_config" {}

module "job_source_postgres" {
  source = "git::https://github.com/mingfang/terraform-provider-k8s.git//modules/kubernetes/job"
  name   = "${var.name}"

  command = <<EOF
    until curl -s -H 'Accept:application/json' ${var.kafka_connect}/
    do echo 'Waiting for Kafka Connect...'; sleep 10; done
    curl -s -X DELETE ${var.kafka_connect}/connectors/${var.connector_name}
    curl -s -i -X POST -H 'Accept:application/json' -H 'Content-Type:application/json' \
      ${var.kafka_connect}/connectors/ -d '${var.connector_config}'
EOF
}
