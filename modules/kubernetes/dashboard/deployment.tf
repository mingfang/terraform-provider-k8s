resource "k8s_apps_v1_deployment" "this" {
  metadata {
    labels    = "${local.labels}"
    name      = "${var.name}"
    namespace = "${var.namespace}"
  }

  spec {
    replicas = "${var.replicas}"

    selector {
      match_labels = "${local.labels}"
    }

    strategy {
      rolling_update {
        max_surge       = "25%"
        max_unavailable = "25%"
      }

      type = "RollingUpdate"
    }

    template {
      metadata {
        labels = "${local.labels}"
      }

      spec {
        node_selector = "${var.node_selector}"

        containers = [
          {
            args = [
              "--heapster-host=http://heapster.kube-system:80",
            ]

            env = []

            image = "${var.image}"

            liveness_probe {
              failure_threshold = 3

              http_get {
                path   = "/"
                port   = "${var.port}"
                scheme = "HTTP"
              }

              initial_delay_seconds = 120
              period_seconds        = 10
              success_threshold     = 1
              timeout_seconds       = 30
            }

            name      = "dashboard"
            resources = {}
          },
        ]

        dns_policy                       = "${var.dns_policy}"
        priority_class_name              = "${var.priority_class_name}"
        restart_policy                   = "${var.restart_policy}"
        scheduler_name                   = "${var.scheduler_name}"
        security_context                 = {}
        service_account_name             = "${k8s_core_v1_service_account.this.metadata.0.name}"
        termination_grace_period_seconds = "${var.termination_grace_period_seconds}"
      }
    }
  }
}
