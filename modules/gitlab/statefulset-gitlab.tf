resource "k8s_apps_v1_stateful_set" "gitlab" {
  metadata {
    annotations = "${var.annotations}"
    labels      = "${local.labels}"
    name        = "${var.name}"
    namespace   = "${var.namespace}"
  }

  spec {
    replicas              = "${var.replicas}"
    service_name          = "${k8s_core_v1_service.gitlab.metadata.0.name}"
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
                name  = "GITLAB_ROOT_PASSWORD"
                value = "${var.gitlab_root_password}"
              },
              {
                name  = "GITLAB_SHARED_RUNNERS_REGISTRATION_TOKEN"
                value = "${var.gitlab_runners_registration_token}"
              },
              {
                name  = "AUTO_DEVOPS_DOMAIN"
                value = "${var.auto_devops_domain}"
              },
              {
                name  = "GITLAB_OMNIBUS_CONFIG"
                value = "${local.gitlab_omnibus_config}"
              },
            ]

            name  = "gitlab"
            image = "${var.image}"

            liveness_probe = [
              {
                failure_threshold = 3

                http_get = [
                  {
                    path   = "/help"
                    port   = "${var.port}"
                    scheme = "HTTP"
                  },
                ]

                initial_delay_seconds = 300
                period_seconds        = 10
                success_threshold     = 1
                timeout_seconds       = 1
              },
            ]

            readiness_probe = [
              {
                failure_threshold = 3

                http_get = [
                  {
                    path   = "/help"
                    port   = "${var.port}"
                    scheme = "HTTP"
                  },
                ]

                period_seconds    = 10
                success_threshold = 1
                timeout_seconds   = 1
              },
            ]

            resources = {}

            volume_mounts = [
              {
                mount_path = "/var/opt/gitlab"
                name       = "${var.volume_claim_template_name}"
                sub_path   = "gitlab/var/opt/gitlab"
              },
              {
                mount_path = "/etc/gitlab"
                name       = "${var.volume_claim_template_name}"
                sub_path   = "gitlab/etc/gitlab"
              },
            ]
          },
        ]

        security_context {}

        service_account_name = "${k8s_rbac_authorization_k8s_io_v1_cluster_role_binding.gitlab.subjects.0.name}"
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

  //  depends_on = [
  //    "k8s_rbac_authorization_k8s_io_v1_cluster_role_binding.gitlab"
  //  ]
}
