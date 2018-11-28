resource "k8s_core_v1_service" "redis-master" {
  metadata {
    labels {
      "role" = "master"
      "tier" = "backend"
      "app"  = "redis"
    }

    name = "redis-master"
  }

  spec {
    ports = [
      {
        port        = 6379
        target_port = "6379"
      },
    ]

    selector {
      "app"  = "redis"
      "role" = "master"
      "tier" = "backend"
    }
  }
}
