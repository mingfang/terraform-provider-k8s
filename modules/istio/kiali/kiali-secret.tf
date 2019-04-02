resource "k8s_core_v1_secret" "kiali" {
  data = {
    "passphrase" = "YWRtaW4="
    "username"   = "YWRtaW4="
  }
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
  type = "Opaque"
}