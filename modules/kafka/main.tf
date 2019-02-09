/*
common variables
*/

variable "name" {}

variable "namespace" {
  default = ""
}

variable "replicas" {
  default = 1
}

variable image {
  default = "confluentinc/cp-kafka"
}

variable ports {
  type = "list"

  default = [
    {
      name = "tcp"
      port = 9092
    },
  ]
}

variable "annotations" {
  type    = "map"
  default = {}
}

variable "node_selector" {
  type    = "map"
  default = {}
}

variable "dns_policy" {
  default = ""
}

variable "priority_class_name" {
  default = ""
}

variable "restart_policy" {
  default = ""
}

variable "scheduler_name" {
  default = ""
}

variable "termination_grace_period_seconds" {
  default = 30
}

variable "session_affinity" {
  default = ""
}

variable "service_type" {
  default = ""
}

/*
service specific variables
*/

variable "kafka_zookeeper_connect" {}

/*
locals
*/

locals {
  labels {
    app     = "${var.name}"
    name    = "${var.name}"
    service = "${var.name}"
  }
}

/*
output
*/

output "name" {
  value = "${k8s_core_v1_service.this.metadata.0.name}"
}

output "ports" {
  value = "${k8s_core_v1_service.this.spec.0.ports}"
}

output "cluster_ip" {
  value = "${k8s_core_v1_service.this.spec.0.cluster_ip}"
}

output "statefulset_uid" {
  value = "${k8s_apps_v1_stateful_set.this.metadata.0.uid}"
}

/*
statefulset specific
*/

variable storage_class_name {}

variable storage {}

variable volume_claim_template_name {
  default = "pvc"
}
