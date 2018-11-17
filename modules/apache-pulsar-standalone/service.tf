resource "k8s_core_v1_service" "this" {
  metadata {
    labels    = "${local.labels}"
    name      = "${var.name}"
    namespace = "${var.namespace}"
  }

  spec {
    ports = [
      {
        name = "pulsar"
        port = 6650
      },
      {
        name = "http-admin"
        port = 8080
      },
    ]

    selector = "${local.labels}"
  }
}
