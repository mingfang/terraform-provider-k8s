resource "k8s_core_v1_service_account" "istio-grafana-post-install-account" {
  metadata {
    labels = {
      "release"  = "istio"
      "app"      = "grafana"
      "chart"    = "grafana"
      "heritage" = "Tiller"
    }
    name      = "istio-grafana-post-install-account"
    namespace = "${var.namespace}"
  }
}