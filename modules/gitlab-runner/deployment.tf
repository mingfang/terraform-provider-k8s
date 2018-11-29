resource "k8s_apps_v1_deployment" "this" {
  metadata {
    annotations = "${var.annotations}"
    labels      = "${local.labels}"
    name        = "${var.name}"
    namespace   = "${var.namespace}"
  }

  spec {
    replicas = "${var.replicas}"

    selector {
      match_labels = "${local.labels}"
    }

    strategy {
      type = "RollingUpdate"

      rolling_update {
        max_surge       = "25%"
        max_unavailable = "25%"
      }
    }

    template {
      metadata {
        labels = "${local.labels}"
      }

      spec {
        containers = [
          {
            name  = "runner"
            image = "${var.image}"

            command = [
              "sh",
              "-cex",
              <<-EOF
              mkdir -p /etc/gitlab-runner/
              cp /config/config.toml /etc/gitlab-runner/
              /entrypoint register \
                --non-interactive \
                --registration-token "${var.registration_token}" \
                --url "${var.gitlab_url}" \
                --executor "kubernetes" \
                --kubernetes-privileged "true"
              /entrypoint run
              EOF
              ,
            ]

            lifecycle {
              pre_stop {
                exec {
                  command = [
                    "gitlab-runner",
                    "unregister",
                    "--all-runners",
                  ]
                }
              }
            }

            resources {}

            volume_mounts = [
              {
                mount_path = "/config"
                name       = "config"
              },
              {
                mount_path = "/var/run/docker.sock"
                name       = "docker"
              },
              {
                mount_path = "/etc/gitlab-runner"
                name       = "etc-gitlab-runner"
              },
            ]
          },
        ]

        security_context = {}

        dns_policy                       = "${var.dns_policy}"
        node_selector                    = "${var.node_selector}"
        priority_class_name              = "${var.priority_class_name}"
        restart_policy                   = "${var.restart_policy}"
        scheduler_name                   = "${var.scheduler_name}"
        service_account_name             = "${k8s_core_v1_service_account.this.metadata.0.name}"
        termination_grace_period_seconds = "${var.termination_grace_period_seconds}"

        volumes = [
          {
            name = "config"

            config_map {
              name = "${k8s_core_v1_config_map.this.metadata.0.name}"
            }
          },
          {
            host_path {
              path = "/var/run/docker.sock"
            }

            name = "docker"
          },
          {
            empty_dir {
              medium = "Memory"
            }

            name = "etc-gitlab-runner"
          },
        ]

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
  }

  depends_on = [
    "k8s_rbac_authorization_k8s_io_v1_cluster_role_binding.this",
  ]

  lifecycle {
    ignore_changes = ["metadata.0.annotations"]
  }
}
