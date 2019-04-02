resource "k8s_core_v1_service_account" "istio-galley-service-account" {
  metadata {
    labels = {
      "heritage" = "Tiller"
      "release"  = "istio"
      "app"      = "galley"
      "chart"    = "galley"
    }
    name      = "istio-galley-service-account"
    namespace = "${var.namespace}"
  }
}