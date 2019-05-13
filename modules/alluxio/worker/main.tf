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
          {
            name  = "ALLUXIO_WORKER_DATA_SERVER_DOMAIN_SOCKET_ADDRESS"
            value = "/opt/domain"
          },
          {
            name  = "ALLUXIO_WORKER_DATA_SERVER_DOMAIN_SOCKET_AS_UUID"
            value = "true"
          },
          {
            name  = "ALLUXIO_LOCALITY_NODE"
            value_from = {
              field_ref = {
                field_path = "spec.nodeName"
              }
            }
          },
        ], var.env)

        volume_mounts = [
          {
            name       = "alluxio-ramdisk"
            mount_path = "/dev/shm"
          },
          {
            name       = "alluxio-domain"
            mount_path = "/opt/domain"
          },
        ]
      }
    ]
    volumes = [
      {
        name = "alluxio-ramdisk"
        empty_dir = {
          medium    = "Memory"
          sizeLimit = "1G"
        }
      },
      {
        name = "alluxio-domain"
        host_path = {
          path    = "/tmp/domain"
          type = "DirectoryOrCreate"
        }
      },
    ]
  }
}


module "daemonset" {
  source     = "git::https://github.com/mingfang/terraform-provider-k8s.git//archetypes/daemonset"
  parameters = merge(local.parameters, var.overrides)
}
