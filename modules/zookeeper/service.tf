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

    selector         = "${local.labels}"
    session_affinity = "${var.session_affinity}"
    type             = "${var.service_type}"
  }
}
