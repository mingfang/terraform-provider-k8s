module "ingress-controller" {
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
        host = "gitlab.${var.ingress_host}.nip.io"

        http {
          paths = [
            {
              path = "/"

              backend {
                service_name = "${var.name}"
                service_port = "80"
              }
            },
          ]
        }
      },
      {
        host = "mattermost.gitlab.${var.ingress_host}.nip.io"

        http {
          paths = [
            {
              path = "/"

              backend {
                service_name = "${var.name}"
                service_port = "80"
              }
            },
          ]
        }
      },
      {
        host = "registry.gitlab.${var.ingress_host}.nip.io"

        http {
          paths = [
            {
              path = "/"

              backend {
                service_name = "${var.name}"
                service_port = "80"
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
