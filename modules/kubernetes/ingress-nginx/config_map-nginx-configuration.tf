resource "k8s_core_v1_config_map" "nginx-configuration" {
  metadata {
    labels    = "${local.labels}"
    name      = "${var.name}"
    namespace = "${var.namespace}"
  }
}
