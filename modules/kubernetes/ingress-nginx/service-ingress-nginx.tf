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
        name        = "http"
        protocol    = "TCP"
        port        = "${var.port}"
        target_port = 80
        node_port   = "${var.node_port_http}"
      },
      {
        name        = "https"
        protocol    = "TCP"
        port        = 443
        target_port = 443
        node_port   = "${var.node_port_https}"
      },
    ]

    selector = "${local.labels}"
    type     = "NodePort"
  }
}
