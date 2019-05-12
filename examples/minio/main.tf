
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
  namespace = k8s_core_v1_namespace.this.metadata.0.name
}

module "minio-storage" {
  source        = "git::https://github.com/mingfang/terraform-provider-k8s.git//modules/kubernetes/storage-nfs"
  name          = "${var.name}"
  namespace     = k8s_core_v1_namespace.this.metadata.0.name
  replicas      = 4
  mount_options = module.nfs-server.mount_options
  nfs_server    = module.nfs-server.service.spec.0.cluster_ip
  storage       = "2Gi"

  annotations = {
    "nfs-server-uid" = "${module.nfs-server.deployment.metadata.0.uid}"
  }
}

module "minio" {
  source    = "../../modules/minio"
  name      = "${var.name}"
  namespace = k8s_core_v1_namespace.this.metadata.0.name

  replicas           = module.minio-storage.replicas
  storage            = module.minio-storage.storage
  storage_class_name = module.minio-storage.storage_class_name
  minio_access_key   = var.minio_access_key
  minio_secret_key   = var.minio_secret_key
}

module "ingress-rules" {
  source    = "git::https://github.com/mingfang/terraform-provider-k8s.git//modules/kubernetes/ingress-rules"
  name      = var.name
  namespace = k8s_core_v1_namespace.this.metadata.0.name
  ingress_class = "nginx"
  rules = [
    {
      host = "${var.name}.${var.ingress-ip}.nip.io"

      http = {
        paths = [
          {
            path = "/"

            backend = {
              service_name = module.minio.service.metadata.0.name
              service_port = module.minio.service.spec.0.ports.0.port
            }
          },
        ]
      }
    },
  ]
}
