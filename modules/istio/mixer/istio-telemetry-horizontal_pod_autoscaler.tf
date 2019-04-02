resource "k8s_autoscaling_v2beta1_horizontal_pod_autoscaler" "istio-telemetry" {
  metadata {
    labels = {
      "heritage" = "Tiller"
      "release"  = "istio"
      "app"      = "mixer"
      "chart"    = "mixer"
    }
    name      = "istio-telemetry"
    namespace = "${var.namespace}"
  }
  spec {
    max_replicas = 5

    metrics {
      resource {
        name                       = "cpu"
        target_average_utilization = 80
      }
      type = "Resource"
    }
    min_replicas = 1
    scale_target_ref {
      api_version = "apps/v1beta1"
      kind        = "Deployment"
      name        = "istio-telemetry"
    }
  }
}