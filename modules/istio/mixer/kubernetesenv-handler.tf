resource "k8s_config_istio_io_v1alpha2_handler" "kubernetesenv" {
  metadata {
    labels = {
      "heritage" = "Tiller"
      "release"  = "istio"
      "app"      = "mixer"
      "chart"    = "mixer"
    }
    name      = "kubernetesenv"
    namespace = "${var.namespace}"
  }
  spec = <<-JSON
    {
      "compiledAdapter": "kubernetesenv",
      "params": null
    }
    JSON
}