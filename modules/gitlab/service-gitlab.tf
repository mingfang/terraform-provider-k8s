resource "k8s_core_v1_service" "gitlab" {
  metadata {
    annotations = "${var.annotations}"
    labels      = "${local.labels}"
    name        = "${var.name}"
    namespace   = "${var.namespace}"
  }

  spec {
    ports = [
      {
        name = "http"
        port = "${var.port}"
      },
    ]

    selector = "${local.labels}"
  }
}
