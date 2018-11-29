resource "k8s_core_v1_service_account" "this" {
  metadata {
    labels    = "${local.labels}"
    name      = "${var.name}"
    namespace = "${var.namespace}"
  }
}
