variable "name" {}
variable "count" {}

module "nfs-server" {
  source = "git::https://github.com/mingfang/terraform-provider-k8s.git//modules/nfs-server-empty-dir"
  name   = "${var.name}-nfs-server"
}

locals {
  mount_options = [
    "nfsvers=4.2",
    "proto=tcp",
    "port=2049",
  ]
}

module "storage" {
  source  = "git::https://github.com/mingfang/terraform-provider-k8s.git//modules/kubernetes/storage-nfs"
  name    = "${var.name}"
  count   = "${var.count}"
  storage = "1Gi"

  annotations {
    "nfs-server-uid" = "${module.nfs-server.deployment_uid}"
  }

  nfs_server    = "${module.nfs-server.cluster_ip}"
  mount_options = "${local.mount_options}"
}

output "count" {
  value = "${var.count}"
}

output "storage_class_name" {
  value = "${module.storage.storage_class_name}"
}

output "storage" {
  value = "${module.storage.storage}"
}
