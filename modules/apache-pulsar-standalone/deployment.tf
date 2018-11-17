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

    template {
      metadata {
        labels = "${local.labels}"
      }

      spec {
        node_selector = "${var.node_selector}"

        containers = [
          {
            image = "${var.image}"
            name  = "pulsar"

            command = [
              "bin/pulsar",
              "standalone",
            ]
          },
        ]
      }
    }
  }
}
