resource "k8s_core_v1_service" "istio-galley" {
  metadata {
    labels = {
      "heritage" = "Tiller"
      "istio"    = "galley"
      "release"  = "istio"
      "app"      = "galley"
      "chart"    = "galley"
    }
    name      = "istio-galley"
    namespace = "${var.namespace}"
  }
  spec {

    ports {
      name = "https-validation"
      port = 443
    }
    ports {
      name = "http-monitoring"
      port = 15014
    }
    ports {
      name = "grpc-mcp"
      port = 9901
    }
    selector = {
      "istio" = "galley"
    }
  }
}