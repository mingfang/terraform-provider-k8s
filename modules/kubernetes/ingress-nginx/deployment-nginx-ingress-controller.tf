resource "k8s_apps_v1_deployment" "this" {
  metadata {
    labels    = "${local.labels}"
    name      = "${var.name}"
    namespace = "${k8s_core_v1_namespace.ingress-nginx.metadata.0.name}"
  }

  spec {
    replicas = "${var.replicas}"

    selector {
      match_labels = "${local.labels}"
    }

    strategy {
      type = "RollingUpdate"

      rolling_update {
        max_surge       = "25%"
        max_unavailable = "25%"
      }
    }

    template {
      metadata {
        annotations {
          "prometheus.io/port"   = "10254"
          "prometheus.io/scrape" = "true"
        }

        labels = "${local.labels}"
      }

      spec {
        node_selector = "${var.node_selector}"

        containers = [
          {
            args = [
              "/nginx-ingress-controller",
              "--configmap=$(POD_NAMESPACE)/${k8s_core_v1_config_map.nginx-configuration.metadata.0.name}",
              "--publish-service=$(POD_NAMESPACE)/${var.name}",
              "--annotations-prefix=${var.annotations_prefix}",
            ]

            env = [
              {
                name = "POD_NAME"

                value_from {
                  field_ref {
                    field_path = "metadata.name"
                  }
                }
              },
              {
                name = "POD_NAMESPACE"

                value_from {
                  field_ref {
                    field_path = "metadata.namespace"
                  }
                }
              },
            ]

            image = "${var.image}"

            liveness_probe {
              failure_threshold = 3

              http_get {
                path   = "/healthz"
                port   = "10254"
                scheme = "HTTP"
              }

              initial_delay_seconds = 10
              period_seconds        = 10
              success_threshold     = 1
              timeout_seconds       = 1
            }

            name = "nginx-ingress-controller"

            ports = [
              {
                container_port = 80
                name           = "http"
              },
              {
                container_port = 443
                name           = "https"
              },
            ]

            readiness_probe {
              failure_threshold = 3

              http_get {
                path   = "/healthz"
                port   = "10254"
                scheme = "HTTP"
              }

              period_seconds    = 10
              success_threshold = 1
              timeout_seconds   = 1
            }

            resources {}

            security_context {
              capabilities {
                add = [
                  "NET_BIND_SERVICE",
                ]

                drop = [
                  "ALL",
                ]
              }

              run_asuser = 33
            }
          },
        ]

        security_context {}

        service_account_name = "${k8s_core_v1_service_account.nginx-ingress-serviceaccount.metadata.0.name}"
      }
    }
  }
}
