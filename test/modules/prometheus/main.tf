/**
 * go test -v test/modules/prometheus/basic_test.go
 */

variable "name" {
  default = "test"
}

variable "ingress_host" {
  default = "192.168.2.146"
}

module "ingress-controller" {
  source = "../../../test/fixtures/ingress"
  name   = "${var.name}"
}

module "storage" {
  source = "../../../test/fixtures/storage"
  name   = "${var.name}"
  count  = 1
}

module "prometheus" {
  source             = "../../../modules/prometheus"
  name               = "${var.name}"
  storage_class_name = "${module.storage.storage_class_name}"
  storage            = "${module.storage.storage}"
  replicas           = "${module.storage.count}"
}

resource "k8s_extensions_v1beta1_ingress" "this" {
  metadata {
    name = "${var.name}-ingress"

    annotations {
      "kubernetes.io/ingress.class" = "nginx"
    }
  }

  spec {
    rules = [
      {
        host = "${module.prometheus.name}.${var.ingress_host}.nip.io"

        http {
          paths = [
            {
              path = "/"

              backend {
                service_name = "${module.prometheus.name}"
                service_port = "${module.prometheus.port}"
              }
            },
          ]
        }
      },
    ]
  }
}

output "url" {
  value = "http://${module.prometheus.name}.${var.ingress_host}.nip.io:${module.ingress-controller.node_port_http}"
}
