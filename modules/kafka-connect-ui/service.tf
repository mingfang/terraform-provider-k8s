resource "k8s_core_v1_service" "this" {
  metadata {
    name        = "${var.name}"
    namespace   = "${var.namespace}"
    labels      = "${local.labels}"
    annotations = "${var.annotations}"
  }

  spec {
    selector = "${local.labels}"

    ports = [
      {
        name = "http"
        port = 8000
      },
    ]
  }
}
