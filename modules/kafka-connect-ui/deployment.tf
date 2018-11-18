resource "k8s_apps_v1_deployment" "this" {
  metadata {
    name      = "${var.name}"
    namespace = "${var.namespace}"
    labels    = "${local.labels}"
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
        node_selector = "${var.node_selector}"

        containers = [
          {
            name  = "kafka-connect-ui"
            image = "${var.image}"

            env = [
              {
                name  = "CONNECT_URL"
                value = "${var.kafka_connect}"
              },
            ]

            resources {}
          },
        ]

        security_context {}
      }
    }
  }
}
