resource "k8s_core_v1_namespace" "ingress-nginx" {
  metadata {
    labels = "${local.labels}"
    name   = "${var.namespace}"
  }
}
