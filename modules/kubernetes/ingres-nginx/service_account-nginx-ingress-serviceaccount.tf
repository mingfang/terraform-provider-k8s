resource "k8s_core_v1_service_account" "nginx-ingress-serviceaccount" {
  metadata {
    labels    = "${local.labels}"
    name      = "${var.name}"
    namespace = "${k8s_core_v1_namespace.ingress-nginx.metadata.0.name}"
  }
}
