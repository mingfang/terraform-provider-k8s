resource "k8s_apps_v1_deployment" "redis-master"{
  metadata {
    name = "redis-master"
  }
  spec {
    replicas = 1
    selector {
      match_labels {
        "app" = "redis"
        "role" = "master"
        "tier" = "backend"
      }
    }
    template {
      metadata {
        labels {
          "app" = "redis"
          "role" = "master"
          "tier" = "backend"
        }
      }
      spec {
        containers = [
          {
            image = "k8s.gcr.io/redis:e2e"
            name = "master"
            ports = [
              {
                container_port = 6379
              },
            ]
            resources {
              requests {
                "cpu" = "100m"
                "memory" = "100Mi"
              }
            }
          },
        ]
      }
    }
  }
}