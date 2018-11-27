/**
 * [Kibana](https://www.elastic.co/products/kibana)
 *
 *
 */

/*
common variables
*/

variable "name" {
  default = "kibana"
}

variable "namespace" {
  default = ""
}

variable "replicas" {
  default = 1
}

variable image {
  default = "docker.elastic.co/kibana/kibana:6.5.1"
}

variable port {
  default = 5601
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

variable "session_affinity" {
  default = ""
}

variable "service_type" {
  default = ""
}

/*
service specific variables
*/

variable "server_name" {
  default = "kibana"
}

variable "server_host" {
  default = "0.0.0.0"
}

variable "elasticsearch_url" {
  default = "http://elasticsearch:9200"
}

variable "xpack_monitoring_ui_container_elasticsearch_enabled" {
  default = "true"
}

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

output "port" {
  value = "${k8s_core_v1_service.this.spec.0.ports.0.port}"
}

output "cluster_ip" {
  value = "${k8s_core_v1_service.this.spec.0.cluster_ip}"
}

output "deployment_uid" {
  value = "${k8s_apps_v1_deployment.this.metadata.0.uid}"
}
