resource "k8s_apps_v1_deployment" "gitlab-runner" {
  metadata {
    labels    = "${local.labels}"
    name      = "${var.name}"
    namespace = "${var.namespace}"
  }

  spec {
    replicas = "${var.replicas}"

    selector {
      match_labels = "${local.labels}"
    }

    strategy {
      rolling_update {
        max_surge       = "25%"
        max_unavailable = "25%"
      }

      type = "RollingUpdate"
    }

    template {
      metadata {
        labels = "${local.labels}"
      }

      spec {
        node_selector = "${var.node_selector}"

        containers = [
          {
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

            image = "${var.image}"

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

            name      = "runner"
            resources = {}

            volume_mounts = [
              {
                mount_path = "/var/run/docker.sock"
                name       = "docker"
              },
              {
                mount_path = "/etc/gitlab-runner"
                name       = "etc-gitlab-runner"
              },
              {
                mount_path = "/config"
                name       = "config"
              },
            ]
          },
        ]

        security_context {}

        service_account_name = "${k8s_core_v1_service_account.gitlab-runner.metadata.0.name}"

        volumes = [
          {
            config_map {
              name = "${k8s_core_v1_config_map.gitlab-runner.metadata.0.name}"
            }

            name = "config"
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
      }
    }
  }
}
