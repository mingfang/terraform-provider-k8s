resource "k8s_apps_v1_deployment" "this" {
  metadata {
    annotations = "${var.annotations}"
    labels      = "${local.labels}"
    name        = "${var.name}"
    namespace   = "${var.namespace}"
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
        containers = [
          {
            name  = "nginx-ingress-controller"
            image = "${var.image}"

            args = [
              "/nginx-ingress-controller",
              "--configmap=$(POD_NAMESPACE)/${k8s_core_v1_config_map.this.metadata.0.name}",
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

            liveness_probe {
              failure_threshold     = 3
              initial_delay_seconds = 10
              period_seconds        = 10
              success_threshold     = 1
              timeout_seconds       = 1

              http_get {
                path   = "/healthz"
                port   = "10254"
                scheme = "HTTP"
              }
            }

            readiness_probe {
              failure_threshold = 3
              period_seconds    = 10
              success_threshold = 1
              timeout_seconds   = 1

              http_get {
                path   = "/healthz"
                port   = "10254"
                scheme = "HTTP"
              }
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

        dns_policy                       = "${var.dns_policy}"
        node_selector                    = "${var.node_selector}"
        priority_class_name              = "${var.priority_class_name}"
        restart_policy                   = "${var.restart_policy}"
        scheduler_name                   = "${var.scheduler_name}"
        service_account_name             = "${k8s_core_v1_service_account.this.metadata.0.name}"
        termination_grace_period_seconds = "${var.termination_grace_period_seconds}"
      }
    }
  }

  depends_on = [
    "k8s_rbac_authorization_k8s_io_v1_cluster_role_binding.this",
    "k8s_rbac_authorization_k8s_io_v1_role_binding.this",
  ]

  lifecycle {
    ignore_changes = ["metadata.0.annotations"]
  }
}
