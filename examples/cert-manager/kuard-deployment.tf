resource "k8s_extensions_v1beta1_deployment" "kuard" {
  metadata {
    name = "kuard"
  }
  spec {
    replicas = 1
    template {
      metadata {
        labels = {
          "app" = "kuard"
        }
      }
      spec {

        containers {
          image             = "gcr.io/kuar-demo/kuard-amd64:1"
          image_pull_policy = "Always"
          name              = "kuard"

          ports {
            container_port = 8080
          }
        }
      }
    }
  }
}