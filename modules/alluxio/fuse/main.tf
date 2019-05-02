/**
 * Documentation
 *
 * terraform-docs --sort-inputs-by-required --with-aggregate-type-defaults md
 *
 */

locals {
  parameters = {
    name      = var.name
    namespace = var.namespace
    enable_service_links = false
    containers = [
      {
        name  = "alluxio"
        image = var.image
        args = [
          "fuse"
        ]
        env = [
          {
            name = "ALLUXIO_MASTER_HOSTNAME"
            value = var.alluxio_master_hostname
          },
          {
            name = "ALLUXIO_MASTER_PORT"
            value = var.alluxio_master_port
          },
        ]
        lifecycle = {
          pre_stop = {
            exec = {
              command = ["/opt/alluxio/integration/fuse/bin/alluxio-fuse", "unmount", "/alluxio-fuse"]
            }
          }
        }
        security_context = {
          privileged = true
          capabilities = {
            add = [
              "SYS_ADMIN",
            ]
          }
        }
        volume_mounts = [
          {
            name = "alluxio-fuse-device"
            mount_path = "/dev/fuse"
          },
          {
            name = "alluxio-fuse-mount"
            mount_path = "/alluxio-fuse"
            mount_propagation = "Bidirectional"
          }
        ]
      }
    ]
    volumes = [
      {
        name = "alluxio-fuse-device"
        host_path = {
          path = "/dev/fuse"
          type = "File"
        }
      },
      {
        name = "alluxio-fuse-mount"
        host_path = {
          path = "/alluxio-fuse"
          type = "DirectoryOrCreate"
        }
      }
    ]
  }
}


module "daemonset" {
  source     = "git::https://github.com/mingfang/terraform-provider-k8s.git//archetypes/daemonset"
  parameters = merge(local.parameters, var.overrides)
}
