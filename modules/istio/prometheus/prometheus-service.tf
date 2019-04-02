resource "k8s_core_v1_service" "prometheus" {
  metadata {
    annotations = {
      "prometheus.io/scrape" = "true"
    }
    labels = {
      "heritage" = "Tiller"
      "release"  = "istio"
      "app"      = "prometheus"
      "chart"    = "prometheus"
    }
    name      = "prometheus"
    namespace = "${var.namespace}"
  }
  spec {

    ports {
      name     = "http-prometheus"
      port     = 9090
      protocol = "TCP"
    }
    selector = {
      "app" = "prometheus"
    }
  }
}