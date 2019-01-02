/**
 * Documentation
 *
 * terraform-docs --sort-inputs-by-required --with-aggregate-type-defaults md
 *
 */

/*
common variables
*/

variable "name" {
  default = "hadoop-master"
}

variable "namespace" {
  default = ""
}

variable "replicas" {
  default = 1
}

variable image {
  default = "registry.rebelsoft.com/hadoop:latest"
}

variable port_namenode_http {
  default = 50070
}

variable port_namenode_ipc {
  default = 9000
}

variable port_resourcemanager_http {
  default = 8088
}

variable port_resourcemanager_ipc_0 {
  default = 8030
}

variable port_resourcemanager_ipc_1 {
  default = 8031
}

variable port_resourcemanager_ipc_2 {
  default = 8032
}

variable port_resourcemanager_ipc_3 {
  default = 8033
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
