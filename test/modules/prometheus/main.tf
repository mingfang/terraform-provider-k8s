/**
 * GOCACHE=off go test -v test/modules/prometheus/basic_test.go
 */

variable "name" {
  default = "test-prometheus"
}

variable "ingress_host" {
  default = "192.168.2.146"
}

module "ingress-controller" {
  source    = "../../../test/fixtures/ingress"
  name      = "${var.name}"
  namespace = "${k8s_core_v1_namespace.this.metadata.0.name}"
}

module "storage" {
  source    = "../../../test/fixtures/storage"
  name      = "${var.name}"
  namespace = "${k8s_core_v1_namespace.this.metadata.0.name}"
  count     = 1
}

module "prometheus" {
  source             = "../../../modules/prometheus"
  name               = "${var.name}"
  namespace          = "${k8s_core_v1_namespace.this.metadata.0.name}"
  storage_class_name = "${module.storage.storage_class_name}"
  storage            = "${module.storage.storage}"
  replicas           = "${module.storage.count}"
}

resource "k8s_extensions_v1beta1_ingress" "this" {
  metadata {
    name      = "${var.name}"
    namespace = "${k8s_core_v1_namespace.this.metadata.0.name}"

    annotations {
      "kubernetes.io/ingress.class" = "${module.ingress-controller.ingress_class}"
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
