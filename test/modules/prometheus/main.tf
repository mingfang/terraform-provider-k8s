/**
 * go clean -testcache; go test -v test/modules/prometheus/basic_test.go
 */

variable "name" {
  default = "test-prometheus"
}

variable "ingress_host" {
  default = "192.168.2.146"
}

module "ingress-controller" {
  source    = "../../../test/fixtures/ingress"
  name      = var.name
  namespace = k8s_core_v1_namespace.this.metadata.0.name
}

module "storage" {
  source    = "../../../test/fixtures/storage"
  name      = var.name
  namespace = k8s_core_v1_namespace.this.metadata.0.name
  replicas  = 1
}

module "prometheus" {
  source             = "../../../modules/prometheus"
  name               = var.name
  namespace          = k8s_core_v1_namespace.this.metadata.0.name
  replicas           = module.storage.replicas
  storage            = module.storage.storage
  storage_class_name = module.storage.storage_class_name
}

module "ingress-rules" {
  source        = "../../../modules/kubernetes/ingress-rules"
  name          = var.name
  namespace     = k8s_core_v1_namespace.this.metadata.0.name
  ingress_class = module.ingress-controller.ingress_class
  rules = [
    {
      host = "${module.prometheus.name}.${var.ingress_host}.nip.io"

      http = {
        paths = [
          {
            path = "/"

            backend = {
              service_name = module.prometheus.name
              service_port = module.prometheus.port
            }
          },
        ]
      }
    },
  ]
}

output "url" {
  value = "http://${module.prometheus.name}.${var.ingress_host}.nip.io:${module.ingress-controller.node_port_http}"
}
