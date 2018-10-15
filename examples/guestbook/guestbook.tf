resource "k8s_core_v1_service" "redis-master" {
  metadata {
    name = "redis-master"

    labels {
      app  = "redis"
      tier = "backend"
      role = "master"
    }
  }

  spec {
    selector {
      app  = "redis"
      tier = "backend"
      role = "master"
    }

    ports = [
      {
        port        = 6379
        target_port = 6379
      },
    ]
  }
}

resource "k8s_apps_v1_deployment" "redis-master" {
  metadata {
    name = "redis-master"
  }

  spec {
    selector {
      match_labels {
        app  = "redis"
        tier = "backend"
        role = "master"
      }
    }

    replicas = 1

    template {
      metadata {
        name = "redis-master"

        labels {
          app  = "redis"
          tier = "backend"
          role = "master"
        }
      }

      spec {
        containers = [
          {
            name  = "master"
            image = "k8s.gcr.io/redis:e2e"

            resources {
              requests {
                cpu    = "100m"
                memory = "100Mi"
              }
            }

            ports = [
              {
                container_port = 6379
              },
            ]
          },
        ]
      }
    }
  }
}

resource "k8s_core_v1_service" "redis-slave" {
  metadata {
    name = "redis-slave"

    labels {
      app  = "redis"
      tier = "backend"
      role = "slave"
    }
  }

  spec {
    selector {
      app  = "redis"
      tier = "backend"
      role = "slave"
    }

    ports = [
      {
        port = 6379
      },
    ]
  }
}

resource "k8s_apps_v1_deployment" "redis-slave" {
  metadata {
    name = "redis-slave"
  }

  spec {
    selector {
      match_labels {
        app  = "redis"
        tier = "backend"
        role = "slave"
      }
    }

    replicas = 2

    template {
      metadata {
        name = "redis-slave"

        labels {
          app  = "redis"
          tier = "backend"
          role = "slave"
        }
      }

      spec {
        containers = [
          {
            name  = "slave"
            image = "gcr.io/google_samples/gb-redisslave:v1"

            resources {
              requests {
                cpu    = "100m"
                memory = "100Mi"
              }
            }

            env = [
              {
                name  = "GET_HOSTS_FROM"
                value = "dns"
              },
            ]

            ports = [
              {
                container_port = 6379
              },
            ]
          },
        ]
      }
    }
  }
}

resource "k8s_core_v1_service" "frontend" {
  metadata {
    name = "frontend"

    labels {
      app  = "guestbook"
      tier = "frontend"
    }
  }

  spec {
    ports = [
      {
        port = 80
      },
    ]

    selector {
      app  = "guestbook"
      tier = "frontend"
    }
  }
}

resource "k8s_apps_v1_deployment" "frontend" {
  metadata {
    name = "frontend"
  }

  spec {
    selector {
      match_labels {
        app  = "guestbook"
        tier = "frontend"
      }
    }

    replicas = 3

    template {
      metadata {
        labels {
          app  = "guestbook"
          tier = "frontend"
        }
      }

      spec {
        containers = [
          {
            name  = "php-redis"
            image = "gcr.io/google-samples/gb-frontend:v4"

            resources {
              requests {
                cpu    = "100m"
                memory = "100Mi"
              }
            }

            env = [
              {
                name  = "GET_HOSTS_FROM"
                value = "dns"
              },
            ]

            ports = [
              {
                container_port = 80
              },
            ]
          },
        ]
      }
    }
  }
}
