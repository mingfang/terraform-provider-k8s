/**
 * GOCACHE=off go test -v test/solutions/central-logging/basic_test.go
 */

variable "name" {
  default = "test-central-logging"
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
  name      = "${var.name}-es"
  namespace = "${k8s_core_v1_namespace.this.metadata.0.name}"
  count     = 1
}

module "central_logging" {
  source             = "../../../solutions/central-logging"
  name               = "${var.name}"
  namespace          = "${k8s_core_v1_namespace.this.metadata.0.name}"
  storage_class_name = "${module.storage.storage_class_name}"
  storage            = "${module.storage.storage}"
  es_replicas        = "${module.storage.count}"
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
        host = "${module.central_logging.elasticsearch_name}.${var.ingress_host}.nip.io"

        http {
          paths = [
            {
              path = "/"

              backend {
                service_name = "${module.central_logging.elasticsearch_name}"
                service_port = "${module.central_logging.elasticsearch_port}"
              }
            },
          ]
        }
      },
      {
        host = "${module.central_logging.kibana_name}.${var.ingress_host}.nip.io"

        http {
          paths = [
            {
              path = "/"

              backend {
                service_name = "${module.central_logging.kibana_name}"
                service_port = "${module.central_logging.kibana_port}"
              }
            },
          ]
        }
      },
    ]
  }
}

output "elasticsearch_url" {
  value = "http://${module.central_logging.elasticsearch_name}.${var.ingress_host}.nip.io:${module.ingress-controller.node_port_http}"
}

output "kibana_url" {
  value = "http://${module.central_logging.kibana_name}.${var.ingress_host}.nip.io:${module.ingress-controller.node_port_http}"
}
