resource "k8s_core_v1_namespace" "this" {
  metadata {
    labels = {
      "istio-injection" = "disabled"
    }

    name = var.namespace
  }
}

module "nfs-server" {
  source    = "../modules/nfs-server-empty-dir"
  name      = "${var.name}-nfs-server"
  namespace = k8s_core_v1_namespace.this.metadata.0.name
  medium    = "Memory"
}

module "storage" {
  source    = "../modules/kubernetes/storage-nfs"
  name      = var.name
  namespace = k8s_core_v1_namespace.this.metadata.0.name
  replicas  = var.replicas
  storage   = "1Gi"

  annotations = {
    "nfs-server-uid" = module.nfs-server.deployment.metadata.0.uid
  }

  nfs_server    = module.nfs-server.service.spec.0.cluster_ip
  mount_options = module.nfs-server.mount_options
}

module "storage-workspace" {
  source    = "../modules/kubernetes/storage-nfs"
  name      = "${var.name}-workspace"
  namespace = k8s_core_v1_namespace.this.metadata.0.name
  replicas  = var.replicas
  storage   = "1Gi"

  annotations = {
    "nfs-server-uid" = module.nfs-server.deployment.metadata.0.uid
  }

  nfs_server    = module.nfs-server.service.spec.0.cluster_ip
  mount_options = module.nfs-server.mount_options
}

variable "node_port_http" {
  default = "30080"
}

variable "node_port_https" {
  default = "30081"
}

module "ingress-rules" {
  source        = "../modules/kubernetes/ingress-rules"
  name          = var.name
  namespace     = k8s_core_v1_namespace.this.metadata.0.name
  ingress_class = "nginx"
  rules = [
    {
      host = "eclipse.rebelsoft.com"

      http = {
        paths = [
          {
            path = "/"

            backend = {
              service_name = var.name
              service_port = 8080
            }
          },
        ]
      }
    },
  ]
}

