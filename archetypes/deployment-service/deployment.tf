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
        labels = "${local.labels}"
      }

      spec {
        containers = [
          {
            name  = "NAME"
            image = "${var.image}"

            command = []
            args    = []

            env = [
              {
                name = "POD_NAME"

                value_from {
                  field_ref {
                    field_path = "metadata.name"
                  }
                }
              },
            ]

            liveness_probe {
              failure_threshold     = 3
              initial_delay_seconds = 60
              period_seconds        = 10
              success_threshold     = 1
              timeout_seconds       = 1

              http_get {
                path   = "/status"
                port   = "${var.port}"
                scheme = "HTTP"
              }
            }

            readiness_probe {
              failure_threshold     = 3
              initial_delay_seconds = 5
              period_seconds        = 10
              success_threshold     = 1
              timeout_seconds       = 1

              http_get {
                path   = "/status"
                port   = "${var.port}"
                scheme = "HTTP"
              }
            }

            resources {}

            volume_mounts = [
              {
                mount_path = "/config"
                name       = "config"
              },
            ]
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

        volumes = [
          {
            name = "config"

            config_map {
              name = "${k8s_core_v1_config_map.this.metadata.0.name}"
            }
          },
        ]

        affinity {
          pod_anti_affinity {
            required_during_scheduling_ignored_during_execution {
              label_selector {
                match_expressions {
                  key      = "app"
                  operator = "In"
                  values   = ["${var.name}"]
                }
              }

              topology_key = "kubernetes.io/hostname"
            }
          }
        }
      }
    }
  }

  depends_on = [
    "k8s_rbac_authorization_k8s_io_v1_cluster_role_binding.this",
  ]

  lifecycle {
    ignore_changes = ["metadata.0.annotations"]
  }
}
