/**
 * Documentation
 *
 * terraform-docs --sort-inputs-by-required --with-aggregate-type-defaults md
 *
 */

locals {
  parameters = {
    name                 = var.name
    namespace            = var.namespace
    enable_service_links = false
    containers = [
      {
        name  = "alluxio"
        image = var.image
        args = [
          "worker"
        ]
        env = concat([
          {
            name = "ALLUXIO_WORKER_HOSTNAME"
            value_from = {
              field_ref = {
                field_path = "status.podIP"
              }
            }
          },
          {
            name  = "ALLUXIO_MASTER_HOSTNAME"
            value = var.alluxio_master_hostname
          },
          {
            name  = "ALLUXIO_MASTER_PORT"
            value = var.alluxio_master_port
          },
        ], var.env)
        volume_mounts = [
          {
            name       = "shm"
            mount_path = "/dev/shm"
          },
        ]
      }
    ]
    volumes = [
      {
        name = "shm"
        empty_dir = {
          medium = "Memory"
        }
      },
    ]
  }
}


module "daemonset" {
  source     = "git::https://github.com/mingfang/terraform-provider-k8s.git//archetypes/daemonset"
  parameters = merge(local.parameters, var.overrides)
}
