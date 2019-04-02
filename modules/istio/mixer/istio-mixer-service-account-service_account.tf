resource "k8s_core_v1_service_account" "istio-mixer-service-account" {
  metadata {
    labels = {
      "heritage" = "Tiller"
      "release"  = "istio"
      "app"      = "mixer"
      "chart"    = "mixer"
    }
    name      = "istio-mixer-service-account"
    namespace = "${var.namespace}"
  }
}