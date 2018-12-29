module "ingress-controller" {
  source = "git::https://github.com/mingfang/terraform-provider-k8s.git//modules/kubernetes/ingress-nginx"
  name   = "${var.name}"
}

resource "k8s_extensions_v1beta1_ingress" "this" {
  metadata {
    name = "${var.name}"

    annotations {
      "kubernetes.io/ingress.class" = "${module.ingress-controller.ingress_class}"
    }
  }

  spec {
    rules = [
      {
        host = "kafka-connect-ui.${var.ingress_host}.nip.io:${module.ingress-controller.node_port_http}"

        http {
          paths = [
            {
              path = "/"

              backend {
                service_name = "${module.debezium.kafka_connect_ui_name}"
                service_port = "8000"
              }
            },
          ]
        }
      },
      {
        host = "kafka-topic-ui.${var.ingress_host}.nip.io:${module.ingress-controller.node_port_http}"

        http {
          paths = [
            {
              path = "/"

              backend {
                service_name = "${module.debezium.kafka_topic_ui_name}"
                service_port = "8000"
              }
            },
          ]
        }
      },
      {
        host = "elasticsearch.${var.ingress_host}.nip.io:${module.ingress-controller.node_port_http}"

        http {
          paths = [
            {
              path = "/"

              backend {
                service_name = "${module.elasticsearch.name}"
                service_port = "${module.elasticsearch.port}"
              }
            },
          ]
        }
      },
    ]
  }
}

output "urls" {
  value = [
    "http://${k8s_extensions_v1beta1_ingress.this.spec.0.rules.0.host}",
    "http://${k8s_extensions_v1beta1_ingress.this.spec.0.rules.1.host}",
    "http://${k8s_extensions_v1beta1_ingress.this.spec.0.rules.2.host}",
  ]
}
