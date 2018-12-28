resource "k8s_apps_v1_deployment" "this" {
  metadata {
    name      = "${var.name}"
    namespace = "${var.namespace}"
    labels    = "${local.labels}"
  }

  spec {
    replicas = "${var.replicas}"

    selector {
      match_labels = "${local.labels}"
    }

    template {
      metadata {
        labels = "${local.labels}"
      }

      spec {
        node_selector = "${var.node_selector}"

        containers = [
          {
            name  = "nfs-server"
            image = "${var.image}"

            env = [
              {
                name  = "SHARED_DIRECTORY"
                value = "/data"
              },
            ]

            security_context {
              privileged = true
            }

            volume_mounts = [
              {
                mount_path = "/data"
                name       = "data"
              },
            ]
          },
        ]

        volumes = [
          {
            name = "data"

            empty_dir = {
              medium = "${var.medium}"
            }
          },
        ]
      }
    }
  }
}
