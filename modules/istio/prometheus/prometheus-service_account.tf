resource "k8s_core_v1_service_account" "prometheus" {
  metadata {
    labels = {
      "release"  = "istio"
      "app"      = "prometheus"
      "chart"    = "prometheus"
      "heritage" = "Tiller"
    }
    name      = "prometheus"
    namespace = "${var.namespace}"
  }
}