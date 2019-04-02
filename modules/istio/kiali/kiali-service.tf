resource "k8s_core_v1_service" "kiali" {
  metadata {
    labels = {
      "heritage" = "Tiller"
      "release"  = "istio"
      "app"      = "kiali"
      "chart"    = "kiali"
    }
    name      = "kiali"
    namespace = "${var.namespace}"
  }
  spec {

    ports {
      name     = "http-kiali"
      port     = 20001
      protocol = "TCP"
    }
    selector = {
      "app" = "kiali"
    }
  }
}