/**
 * [Fluent Bit](https://fluentbit.io)
 *
 * FluentBit Runs as a daemonset sending logs directly to Elasticsearch
 */

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
  default = "fluent/fluent-bit:0.14.8"
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

variable "service_account_name" {
  default = ""
}

variable "termination_grace_period_seconds" {
  default = 30
}

/*
service specific variables
*/

variable "fluent_elasticsearch_host" {}
variable "fluent_elasticsearch_port" {}

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
  value = "${k8s_extensions_v1beta1_daemon_set.this.metadata.0.name}"
}
