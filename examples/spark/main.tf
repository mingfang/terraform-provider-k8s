variable "name" {
  default = "spark"
}

variable "namespace" {
  default = "spark"
}

variable "ingress_ip" {
  default = "192.168.2.146"
}

variable "ingress_node_port" {
  default = "30080"
}

resource "k8s_core_v1_namespace" "this" {
  metadata {
    labels = {
      "istio-injection" = "disabled"
    }
    name = var.namespace
  }
}

module "master" {
  source    = "../../modules/spark/master"
  name      = "${var.name}-master"
  namespace = k8s_core_v1_namespace.this.metadata.0.name
}

module "worker" {
  source     = "../../modules/spark/worker"
  name       = "${var.name}-worker"
  namespace  = k8s_core_v1_namespace.this.metadata.0.name
  replicas   = 1
  master_url = module.master.master_url
}

module "ui-proxy" {
  source      = "../../modules/spark/ui-proxy"
  name        = "${var.name}-ui-proxy"
  namespace   = k8s_core_v1_namespace.this.metadata.0.name
  master_host = module.master.service.metadata.0.name
  master_port = module.master.service.spec.0.ports.1.port
}

module "ingress-rules" {
  source        = "git::https://github.com/mingfang/terraform-provider-k8s.git//modules/kubernetes/ingress-rules"
  name          = var.name
  namespace     = k8s_core_v1_namespace.this.metadata.0.name
  ingress_class = "nginx"
  rules = [
    {
      host = "${var.name}.${var.ingress_ip}.nip.io"

      http = {
        paths = [
          {
            path = "/"

            backend = {
              service_name = module.ui-proxy.service.metadata.0.name
              service_port = module.ui-proxy.service.spec.0.ports.0.port
            }
          },
        ]
      }
    },
  ]
}