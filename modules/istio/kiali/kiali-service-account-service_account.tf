resource "k8s_core_v1_service_account" "kiali-service-account" {
  metadata {
    labels = {
      "release"  = "istio"
      "app"      = "kiali"
      "chart"    = "kiali"
      "heritage" = "Tiller"
    }
    name      = "kiali-service-account"
    namespace = "${var.namespace}"
  }
}