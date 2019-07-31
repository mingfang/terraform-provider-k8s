resource "k8s_apps_v1_deployment" "cert-manager-cainjector" {
  metadata {
    labels = {
      "app"                          = "cainjector"
      "app.kubernetes.io/instance"   = "cert-manager"
      "app.kubernetes.io/managed-by" = "Tiller"
      "app.kubernetes.io/name"       = "cainjector"
      "helm.sh/chart"                = "cainjector-v0.9.0"
    }
    name      = "cert-manager-cainjector"
    namespace = var.namespace
  }
  spec {
    replicas = 1
    selector {
      match_labels = {
        "app"                          = "cainjector"
        "app.kubernetes.io/instance"   = "cert-manager"
        "app.kubernetes.io/managed-by" = "Tiller"
        "app.kubernetes.io/name"       = "cainjector"
      }
    }
    template {
      metadata {
        labels = {
          "app"                          = "cainjector"
          "app.kubernetes.io/instance"   = "cert-manager"
          "app.kubernetes.io/managed-by" = "Tiller"
          "app.kubernetes.io/name"       = "cainjector"
          "helm.sh/chart"                = "cainjector-v0.9.0"
        }
      }
      spec {

        containers {
          args = [
            "--v=2",
            "--leader-election-namespace=$(POD_NAMESPACE)",
          ]

          env {
            name = "POD_NAMESPACE"
            value_from {
              field_ref {
                field_path = "metadata.namespace"
              }
            }
          }
          image             = "quay.io/jetstack/cert-manager-cainjector:v0.9.0"
          image_pull_policy = "IfNotPresent"
          name              = "cainjector"
          resources {
          }
        }
        service_account_name = "cert-manager-cainjector"
      }
    }
  }
}