/**
 * [Nginx Ingress Controller](https://kubernetes.github.io/ingress-nginx/)
 *
 * Based on https://github.com/kubernetes/ingress-nginx/blob/master/deploy/mandatory.yaml
 */

/*
common variables
*/

variable "name" {
  default = "ingress-nginx"
}

variable "namespace" {
  default = "default"
}

variable "replicas" {
  default = 1
}

variable image {
  default = "quay.io/kubernetes-ingress-controller/nginx-ingress-controller:0.21.0"
}

variable port {
  default = 80
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
  default = "NodePort"
}

/*
service specific variables
*/

variable "annotations_prefix" {
  default = "nginx.ingress.kubernetes.io"
}

variable "node_port_http" {
  default = 30000
}

variable "node_port_https" {
  default = 30443
}

/*
locals
*/

locals {
  labels {
    "app.kubernetes.io/name"    = "${var.name}"
    "app.kubernetes.io/part-of" = "${var.name}"
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

output "annotations_prefix" {
  value = "${var.annotations_prefix}"
}

output "node_port_http" {
  value = "${k8s_core_v1_service.this.spec.0.ports.0.node_port}"
}

output "node_port_https" {
  value = "${k8s_core_v1_service.this.spec.0.ports.1.node_port}"
}
