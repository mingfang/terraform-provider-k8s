module "ingress" {
  source = "git::https://github.com/mingfang/terraform-provider-k8s.git//modules/kubernetes/ingress-nginx"
}

resource "k8s_extensions_v1beta1_ingress" "this" {
  metadata {
    name = "${var.name}"

    annotations {
      "kubernetes.io/ingress.class" = "nginx"
    }
  }

  spec {
    rules = [
      {
        host = "kafka-connect-ui.${var.ingress_host}.xip.io"

        http {
          paths = [
            {
              path = "/"

              backend {
                service_name = "${var.name}-kafka-connect-ui"
                service_port = "8000"
              }
            },
          ]
        }
      },
      {
        host = "kafka-topic-ui.${var.ingress_host}.xip.io"

        http {
          paths = [
            {
              path = "/"

              backend {
                service_name = "${var.name}-kafka-topic-ui"
                service_port = "8000"
              }
            },
          ]
        }
      },
      {
        host = "elasticsearch.${var.ingress_host}.xip.io"

        http {
          paths = [
            {
              path = "/"

              backend {
                service_name = "${var.name}-elasticsearch"
                service_port = "9200"
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
    "http://${k8s_extensions_v1beta1_ingress.this.spec.0.rules.0.host}:30000",
    "http://${k8s_extensions_v1beta1_ingress.this.spec.0.rules.1.host}:30000",
    "http://${k8s_extensions_v1beta1_ingress.this.spec.0.rules.2.host}:30000",
  ]
}
