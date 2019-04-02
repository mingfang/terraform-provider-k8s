resource "k8s_policy_v1beta1_pod_disruption_budget" "istio-ingressgateway" {
  metadata {
    labels = {
      "heritage" = "Tiller"
      "istio"    = "ingressgateway"
      "release"  = "istio"
      "app"      = "istio-ingressgateway"
      "chart"    = "gateways"
    }
    name      = "istio-ingressgateway"
    namespace = "${var.namespace}"
  }
  spec {
    min_available = "1"
    selector {
      match_labels = {
        "app"     = "istio-ingressgateway"
        "istio"   = "ingressgateway"
        "release" = "istio"
      }
    }
  }
}