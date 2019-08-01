
module "nfs-server" {
  source    = "git::https://github.com/mingfang/terraform-provider-k8s.git//modules/nfs-server-empty-dir"
  name      = "nfs-server"
}

resource "k8s_core_v1_persistent_volume" "che-data-volume" {
  metadata {
    name = "che-data-volume"
  }
  spec {
    storage_class_name               = "che-data-volume"
    persistent_volume_reclaim_policy = "Retain"
    access_modes                     = ["ReadWriteOnce"]
    capacity = {
      storage = var.user_storage
    }
    nfs {
      path   = "/"
      server = module.nfs-server.service.spec[0].cluster_ip
    }
    mount_options = module.nfs-server.mount_options
  }
}

resource "k8s_core_v1_persistent_volume" "claim-che-workspace" {
  metadata {
    name = "claim-che-workspace"
  }
  spec {
    storage_class_name               = "claim-che-workspace"
    persistent_volume_reclaim_policy = "Retain"
    access_modes                     = ["ReadWriteMany"]
    capacity = {
      storage = var.user_storage
    }
    nfs {
      path   = "/"
      server = module.nfs-server.service.spec[0].cluster_ip
    }
    mount_options = module.nfs-server.mount_options
  }
}

module "eclipse-che" {
  source = "../../modules/eclipse-che"
  che_host = "che-host:8080"
}

module "ingress-rules" {
  source    = "git::https://github.com/mingfang/terraform-provider-k8s.git//modules/kubernetes/ingress-rules"
  name      = var.name
//  namespace = k8s_core_v1_namespace.this.metadata[0].name
  annotations = {
    "nginx.ingress.kubernetes.io/server-alias" = "${var.name}.*",
    "nginx.ingress.kubernetes.io/proxy-connect-timeout" = "3600"
    "nginx.ingress.kubernetes.io/proxy-read-timeout"    = "3600"
    "nginx.ingress.kubernetes.io/ssl-redirect"          = "false"
  }
  ingress_class = "nginx"
  rules = [
    {
      host = var.name

      http = {
        paths = [
          {
            path = "/"

            backend = {
              service_name = module.eclipse-che.service.metadata[0].name
              service_port = module.eclipse-che.service.spec[0].ports[0].port
            }
          },
        ]
      }
    },
  ]
}