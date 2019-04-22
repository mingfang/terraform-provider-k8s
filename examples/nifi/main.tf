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

module "zookeeper_storage" {
  source    = "git::https://github.com/mingfang/terraform-provider-k8s.git//modules/kubernetes/storage-nfs"
  name      = "${var.name}-zookeeper"
  namespace = k8s_core_v1_namespace.this.metadata.0.name
  replicas  = 3
  storage   = "1Gi"

  annotations = {
    "nfs-server-uid" = "${module.nfs-server.deployment.metadata.0.uid}"
  }

  nfs_server    = module.nfs-server.service.spec.0.cluster_ip
  mount_options = module.nfs-server.mount_options
}

module "zookeeper" {
  source    = "git::https://github.com/mingfang/terraform-provider-k8s.git//modules/zookeeper"
  name      = "${var.name}-zookeeper"
  namespace = var.namespace

  storage_class_name = module.zookeeper_storage.storage_class_name
  storage            = module.zookeeper_storage.storage
  replicas           = module.zookeeper_storage.replicas
}

module "nifi" {
  source    = "../../modules/nifi"
  name      = var.name
  namespace = var.namespace
  replicas  = 3
  env = [
    {
      name  = "NIFI_ZK_CONNECT_STRING"
      value = "${module.zookeeper.service.metadata.0.name}:2181"
    },
    {
      name  = "NIFI_CLUSTER_IS_NODE"
      value = "true"
    },
  ]
}

module "ingress-rules" {
  source        = "git::https://github.com/mingfang/terraform-provider-k8s.git//modules/kubernetes/ingress-rules"
  name          = var.name
  namespace     = k8s_core_v1_namespace.this.metadata.0.name
  ingress_class = "nginx"
  annotations = {
    "nginx.ingress.kubernetes.io/configuration-snippet" = <<-EOF
      proxy_set_header X-ProxyPort ${var.ingress-node-port};
      EOF
  }
  rules = [
    {
      host = "${var.name}.${var.ingress-ip}.nip.io"

      http = {
        paths = [
          {
            path = "/"

            backend = {
              service_name = module.nifi.service.metadata.0.name
              service_port = module.nifi.service.spec.0.ports.0.port
            }
          },
        ]
      }
    },
  ]
}


