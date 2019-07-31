resource "k8s_core_v1_service_account" "cert-manager" {
  metadata {
    labels = {
      "app"                          = "cert-manager"
      "app.kubernetes.io/instance"   = "cert-manager"
      "app.kubernetes.io/managed-by" = "Tiller"
      "app.kubernetes.io/name"       = "cert-manager"
      "helm.sh/chart"                = "cert-manager-v0.9.0"
    }
    name      = "cert-manager"
    namespace = var.namespace
  }
}