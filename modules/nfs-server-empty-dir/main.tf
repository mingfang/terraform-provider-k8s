/**
 * Runs a NFS Server serving from an empheral empty dir.
 *
 * WARNING: For demonstration purpose only; You will loose data.
 *
 * Based on https://github.com/kubernetes/examples/tree/master/staging/volumes/nfs
 */

/*
common variables
*/

variable "name" {}

variable "namespace" {
  default = "default"
}

variable "replicas" {
  default = 1
}

variable image {
  default = "itsthenetwork/nfs-server-alpine"
}

variable "annotations" {
  type    = "map"
  default = {}
}

variable "node_selector" {
  type    = "map"
  default = {}
}

/*
service specific variables
*/

//Set to Memory to use tmpfs
variable "medium" {
  default = ""
}

variable port {
  default = 2049
}

locals {
  labels = {
    app     = "${var.name}"
    name    = "${var.name}"
    service = "${var.name}"
  }
}

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
