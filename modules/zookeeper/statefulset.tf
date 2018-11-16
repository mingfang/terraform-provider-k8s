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
            name  = "zookeeper"
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
                name  = "ZOO_DATA_DIR"
                value = "/data/$(POD_NAME)"
              },
              {
                name  = "ZOO_SERVERS"
                value = "${join(" ", data.template_file.zoo-servers.*.rendered)}"
              },
            ]

            liveness_probe {
              initial_delay_seconds = 1
              timeout_seconds       = 3

              exec {
                command = [
                  "/bin/bash",
                  "-cx",
                  "echo 'ruok' | nc localhost 2181 | grep imok",
                ]
              }
            }

            resources {
              requests {
                cpu    = "500m"
                memory = "1Gi"
              }
            }

            volume_mounts {
              name       = "${var.volume_claim_template_name}"
              mount_path = "/data"
              sub_path   = "${var.name}"
            }
          },
        ]

        init_containers = [
          {
            name  = "set-myid"
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
                name  = "ZOO_DATA_DIR"
                value = "/data/$(POD_NAME)"
              },
            ]

            command = [
              "bash",
              "-cx",
              "mkdir -p $ZOO_DATA_DIR; echo \"$${HOSTNAME//[^0-9]/}\" > $ZOO_DATA_DIR/myid",
            ]

            resources {}

            volume_mounts {
              name       = "${var.volume_claim_template_name}"
              mount_path = "/data"
              sub_path   = "${var.name}"
            }
          },
        ]

        security_context {}
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
