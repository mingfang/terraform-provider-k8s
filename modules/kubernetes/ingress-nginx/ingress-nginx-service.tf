resource "k8s_core_v1_service" "ingress-nginx" {
  metadata {
    labels = {
      "app.kubernetes.io/name"    = var.name
      "app.kubernetes.io/part-of" = var.name
    }
    name      = var.name
    namespace = var.namespace
  }
  spec {
    load_balancer_ip = var.load_balancer_ip

    ports {
      name        = "http"
      port        = 80
      protocol    = "TCP"
      target_port = "80"
      node_port   = var.service_type == "NodePort" ? var.node_port_http : null
    }
    ports {
      name        = "https"
      port        = 443
      protocol    = "TCP"
      target_port = "443"
      node_port   = var.service_type == "NodePort" ? var.node_port_https : null
    }
    selector = {
      "app.kubernetes.io/name"    = var.name
      "app.kubernetes.io/part-of" = var.name
    }
    type = var.service_type
  }
}