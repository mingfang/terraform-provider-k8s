resource "k8s_core_v1_service" "ingress-nginx" {
  metadata {
    labels    = "${local.labels}"
    name      = "${var.name}"
    namespace = "${k8s_core_v1_namespace.ingress-nginx.metadata.0.name}"
  }

  spec {
    ports = [
      {
        name        = "http"
        protocol    = "TCP"
        port        = 80
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
