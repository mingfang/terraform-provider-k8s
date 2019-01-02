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
  default = ""
}

variable "replicas" {
  default = 1
}

variable image {
  default = "itsthenetwork/nfs-server-alpine"
}

//list of name,port pairs
variable ports {
  type = "list"

  default = [
    {
      name = "tcp"
      port = 2049
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

/*
service specific variables
*/

//Set to Memory to use tmpfs
variable "medium" {
  default = ""
}

locals {
  labels {
    app     = "${var.name}"
    name    = "${var.name}"
    service = "${var.name}"
  }
}

locals {
  mount_options = [
    "nfsvers=4.2",
    "proto=tcp",
    "port=${lookup(var.ports[0], "port")}",
  ]
}

output "mount_options" {
  value = "${local.mount_options}"
}

output "name" {
  value = "${k8s_core_v1_service.this.metadata.0.name}"
}

output "ports" {
  value = "${k8s_core_v1_service.this.spec.0.ports}"
}

output "cluster_ip" {
  value = "${k8s_core_v1_service.this.spec.0.cluster_ip}"
}

output "deployment_uid" {
  value = "${k8s_apps_v1_deployment.this.metadata.0.uid}"
}
