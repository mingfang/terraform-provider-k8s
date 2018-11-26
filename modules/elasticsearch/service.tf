resource "k8s_core_v1_service" "this" {
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
      {
        name = "tcp"
        port = 9300
      },
    ]

    selector         = "${local.labels}"
    session_affinity = "${var.session_affinity}"
    type             = "${var.service_type}"
  }
}
