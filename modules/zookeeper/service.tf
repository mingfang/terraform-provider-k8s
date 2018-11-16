resource "k8s_core_v1_service" "this" {
  metadata {
    name      = "${var.name}"
    namespace = "${var.namespace}"
    labels    = "${local.labels}"
  }

  spec {
    selector = "${local.labels}"

    ports = [
      {
        name = "client"
        port = "${var.port}"
      },
      {
        name = "server"
        port = 2888
      },
      {
        name = "leader-election"
        port = 3888
      },
    ]
  }
}
