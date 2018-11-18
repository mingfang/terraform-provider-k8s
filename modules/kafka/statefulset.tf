resource "k8s_apps_v1_stateful_set" "this" {
  metadata {
    name      = "${var.name}"
    namespace = "${var.namespace}"
    labels    = "${local.labels}"
  }

  spec {
    replicas              = "${var.replicas}"
    service_name          = "${k8s_core_v1_service.this.metadata.0.name}"
    pod_management_policy = "OrderedReady"

    selector {
      match_labels = "${local.labels}"
    }

    update_strategy {
      type = "RollingUpdate"

      rolling_update {
        partition = 0
      }
    }

    template {
      metadata {
        labels = "${local.labels}"
      }

      spec {
        node_selector = "${var.node_selector}"

        affinity {
          pod_anti_affinity {
            required_during_scheduling_ignored_during_execution {
              label_selector {
                match_expressions {
                  key      = "app"
                  operator = "In"
                  values   = ["${var.name}"]
                }
              }

              topology_key = "kubernetes.io/hostname"
            }
          }
        }

        containers = [
          {
            name  = "kafka"
            image = "${var.image}"

            env = [
              {
                name = "POD_NAME"

                value_from {
                  field_ref {
                    field_path = "metadata.name"
                  }
                }
              },
              {
                name  = "KAFKA_LOG_DIRS"
                value = "/data/$(POD_NAME)"
              },
              {
                name  = "KAFKA_ADVERTISED_LISTENERS"
                value = "PLAINTEXT://$(POD_NAME).${var.name}.${var.namespace}.svc.cluster.local:9092"
              },
              {
                name  = "KAFKA_ZOOKEEPER_CONNECT"
                value = "${var.kafka_zookeeper_connect}"
              },
            ]

            liveness_probe {
              initial_delay_seconds = 1
              timeout_seconds       = 3

              exec {
                command = [
                  "sh",
                  "-ec",
                  "/usr/bin/jps | /bin/grep -q SupportedKafka",
                ]
              }
            }

            readiness_probe {
              tcp_socket {
                port = 9092
              }
            }

            volume_mounts {
              name       = "${var.volume_claim_template_name}"
              mount_path = "/data"
              sub_path   = "${var.name}"
            }
          },
        ]
      }
    }

    volume_claim_templates {
      metadata {
        name = "${var.volume_claim_template_name}"
      }

      spec {
        storage_class_name = "${var.storage_class_name}"
        access_modes       = ["ReadWriteOnce"]

        resources {
          requests {
            storage = "${var.storage}"
          }
        }
      }
    }
  }
}
