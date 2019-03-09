variable "name" {}
variable "namespace" {}
variable "replicas" {}

module "nfs-server" {
  source    = "../../../modules/nfs-server-empty-dir"
  name      = "${var.name}-nfs-server"
  namespace = var.namespace
  medium    = "Memory"
}

module "storage" {
  source    = "../../../modules/kubernetes/storage-nfs"
  name      = var.name
  namespace = var.namespace
  replicas     = var.replicas
  storage   = "1Gi"

  annotations = {
    "nfs-server-uid" = module.nfs-server.deployment.metadata.0.uid
  }

  nfs_server    = module.nfs-server.service.spec.0.cluster_ip
  mount_options = module.nfs-server.mount_options
}

output "replicas" {
  value = module.storage.replicas
}

output "storage_class_name" {
  value = module.storage.storage_class_name
}

output "storage" {
  value = module.storage.storage
}
