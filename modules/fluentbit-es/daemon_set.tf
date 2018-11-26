resource "k8s_extensions_v1beta1_daemon_set" "this" {
  metadata {
    annotations = "${var.annotations}"
    labels      = "${local.labels}"
    name        = "${var.name}"
    namespace   = "${var.namespace}"
  }

  spec {
    template {
      metadata {
        annotations {
          "prometheus.io/scrape" = "true"
          "prometheus.io/path"   = "/api/v1/metrics/prometheus"
          "prometheus.io/port"   = "2020"
        }

        labels = "${local.labels}"
      }

      spec {
        containers = [
          {
            env = [
              {
                name  = "FLUENT_ELASTICSEARCH_HOST"
                value = "${var.fluent_elasticsearch_host}"
              },
              {
                name  = "FLUENT_ELASTICSEARCH_PORT"
                value = "${var.fluent_elasticsearch_port}"
              },
            ]

            image = "${var.image}"
            name  = "fluent-bit"

            volume_mounts = [
              {
                mount_path = "/var/log"
                name       = "varlog"
              },
              {
                mount_path = "/var/lib/docker/containers"
                name       = "varlibdockercontainers"
                read_only  = true
              },
              {
                mount_path = "/fluent-bit/etc/"
                name       = "fluent-bit-config"
              },
            ]
          },
        ]

        service_account_name = "${k8s_core_v1_service_account.this.metadata.0.name}"

        tolerations = [
          {
            effect   = "NoSchedule"
            key      = "node-role.kubernetes.io/master"
            operator = "Exists"
          },
        ]

        volumes = [
          {
            host_path {
              path = "/var/log"
            }

            name = "varlog"
          },
          {
            host_path {
              path = "/var/lib/docker/containers"
            }

            name = "varlibdockercontainers"
          },
          {
            config_map {
              name = "${k8s_core_v1_config_map.this.metadata.0.name}"
            }

            name = "fluent-bit-config"
          },
        ]
      }
    }
  }

  depends_on = [
    "k8s_rbac_authorization_k8s_io_v1_cluster_role_binding.this",
  ]
}
