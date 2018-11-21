resource "k8s_apps_v1_stateful_set" "this" {
  metadata {
    labels    = "${local.labels}"
    name      = "${var.name}"
    namespace = "${var.namespace}"
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
                name  = "REGISTRY_STORAGE_DELETE_ENABLED"
                value = "true"
              },
            ]

            image     = "${var.image}"
            name      = "registry"
            resources = {}

            volume_mounts = [
              {
                mount_path = "/var/lib/registry"
                name       = "${var.volume_claim_template_name}"
                sub_path   = "${var.name}"
              },
            ]
          },
        ]

        dns_policy                       = "${var.dns_policy}"
        priority_class_name              = "${var.priority_class_name}"
        restart_policy                   = "${var.restart_policy}"
        scheduler_name                   = "${var.scheduler_name}"
        security_context                 = {}
        service_account_name             = "${var.service_account_name}"
        termination_grace_period_seconds = "${var.termination_grace_period_seconds}"
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
