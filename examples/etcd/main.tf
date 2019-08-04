
resource "k8s_core_v1_namespace" "this" {
  metadata {
    labels = {
      "istio-injection" = "disabled"
    }

    name = var.namespace
  }
}

module "nfs-server" {
  source    = "git::https://github.com/mingfang/terraform-provider-k8s.git//modules/nfs-server-empty-dir"
  name      = "nfs-server"
  namespace = k8s_core_v1_namespace.this.metadata[0].name
}

module "etcd-storage" {
  source        = "git::https://github.com/mingfang/terraform-provider-k8s.git//modules/kubernetes/storage-nfs"
  name          = "${var.name}"
  namespace     = k8s_core_v1_namespace.this.metadata[0].name
  replicas      = var.replicas
  mount_options = module.nfs-server.mount_options
  nfs_server    = module.nfs-server.service.spec[0].cluster_ip
  storage       = "1Gi"

  annotations = {
    "nfs-server-uid" = "${module.nfs-server.deployment.metadata[0].uid}"
  }
}

module "etcd" {
  source    = "../../modules/etcd"
  name      = "${var.name}"
  namespace = k8s_core_v1_namespace.this.metadata[0].name

  replicas           = module.etcd-storage.replicas
  storage            = module.etcd-storage.storage
  storage_class_name = module.etcd-storage.storage_class_name
}