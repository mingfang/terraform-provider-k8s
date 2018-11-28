resource "k8s_apps_v1_stateful_set" "this" {
  metadata {
    annotations = "${var.annotations}"
    labels      = "${local.labels}"
    name        = "${var.name}"
    namespace   = "${var.namespace}"
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
        containers = [
          {
            name  = "elasticsearch"
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
                name  = "cluster.name"
                value = "${var.name}"
              },
              {
                name  = "node.name"
                value = "$(POD_NAME)"
              },
              {
                name  = "discovery.zen.ping.unicast.hosts"
                value = "${var.name}"
              },
              {
                name  = "ES_JAVA_OPTS"
                value = "-Xms${var.heap_size} -Xmx${var.heap_size}"
              },
              {
                name  = "path.data"
                value = "/data/$(POD_NAME)"
              },
            ]

            liveness_probe {
              failure_threshold     = 3
              initial_delay_seconds = 120
              period_seconds        = 10
              success_threshold     = 1
              timeout_seconds       = 1

              http_get {
                path   = "/"
                port   = "${var.port}"
                scheme = "HTTP"
              }
            }

            readiness_probe {
              failure_threshold     = 3
              initial_delay_seconds = 30
              period_seconds        = 10
              success_threshold     = 1
              timeout_seconds       = 1

              http_get {
                path   = "/"
                port   = "${var.port}"
                scheme = "HTTP"
              }
            }

            resources {
              requests {
                cpu    = "250m"
                memory = "4Gi"
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
            name              = "fix-the-volume-permission"
            image             = "busybox"
            image_pull_policy = "IfNotPresent"

            env = [
              {
                name = "POD_NAME"

                value_from {
                  field_ref {
                    field_path = "metadata.name"
                  }
                }
              },
            ]

            command = [
              "sh",
              "-c",
              "mkdir -p /data/$(POD_NAME) && chown -R 1000:1000 /data/$(POD_NAME)",
            ]

            resources {}

            security_context {
              privileged = true
            }

            volume_mounts {
              name       = "${var.volume_claim_template_name}"
              mount_path = "/data"
              sub_path   = "${var.name}"
            }
          },
          {
            name              = "increase-the-vm-max-map-count"
            image             = "busybox"
            image_pull_policy = "IfNotPresent"

            command = [
              "sysctl",
              "-w",
              "vm.max_map_count=262144",
            ]

            resources {}

            security_context {
              privileged = true
            }
          },
          {
            name              = "increase-the-ulimit"
            image             = "busybox"
            image_pull_policy = "IfNotPresent"

            command = [
              "sh",
              "-c",
              "ulimit -n 65536",
            ]

            resources {}

            security_context {
              privileged = true
            }
          },
        ]

        dns_policy                       = "${var.dns_policy}"
        node_selector                    = "${var.node_selector}"
        priority_class_name              = "${var.priority_class_name}"
        restart_policy                   = "${var.restart_policy}"
        scheduler_name                   = "${var.scheduler_name}"
        security_context                 = {}
        service_account_name             = "${var.service_account_name}"
        termination_grace_period_seconds = "${var.termination_grace_period_seconds}"

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

  lifecycle {
    ignore_changes = ["metadata.0.annotations"]
  }
}
