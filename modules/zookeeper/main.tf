/**
 * Documentation
 *
 * terraform-docs --sort-inputs-by-required --with-aggregate-type-defaults md
 *
 */

locals {
  parameters = {
    name        = var.name
    namespace   = var.namespace
    annotations = var.annotations
    replicas    = var.replicas
    ports       = var.ports
    containers = [
      {
        name  = "zookeeper"
        image = var.image
        env = concat([
          {
            name = "POD_NAME"

            value_from = {
              field_ref = {
                field_path = "metadata.name"
              }
            }
          },
          {
            name  = "ZOO_DATA_DIR"
            value = "/data/$(POD_NAME)"
          },
          {
            name  = "ZOO_SERVERS"
            value = "${join(" ", data.template_file.zoo-servers.*.rendered)}"
          },
        ], var.env)

        command = [
          "bash",
          "-cx",
          <<EOF
          export ZOO_SERVERS=$$(echo $$ZOO_SERVERS|sed "s|$$POD_NAME.${var.name}|0.0.0.0|")
          /docker-entrypoint.sh zkServer.sh start-foreground
          EOF
        ]

        liveness_probe = {
          initial_delay_seconds = 1
          timeout_seconds = 3

          exec = {
            command = [
              "/bin/bash",
              "-cx",
              "echo 'ruok' | nc localhost 2181 | grep imok",
            ]
          }
        }

        resources = {
          requests = {
            cpu = "500m"
            memory = "1Gi"
          }
        }

        volume_mounts = [
          {
            name = var.volume_claim_template_name
            mount_path = "/data"
            sub_path = var.name
          }
        ]
      },
    ]

    init_containers = [
      {
        name = "set-myid"
        image = var.image

        env = [
          {
            name = "POD_NAME"

            value_from = {
              field_ref = {
                field_path = "metadata.name"
              }
            }
          },
          {
            name = "ZOO_DATA_DIR"
            value = "/data/$(POD_NAME)"
          },
        ]

        command = [
          "bash",
          "-cx",
          "mkdir -p $ZOO_DATA_DIR; echo \"$${HOSTNAME//[^0-9]/}\" > $ZOO_DATA_DIR/myid",
        ]

        volume_mounts = [
          {
            name = var.volume_claim_template_name
            mount_path = "/data"
            sub_path = var.name
          }
        ]
      },
    ]

    security_context = {
      fsgroup = 1000
      run_asuser = 1000
    }

    volume_claim_templates = [
      {
        name = var.volume_claim_template_name
        storage_class_name = var.storage_class_name
        access_modes = ["ReadWriteOnce"]

        resources = {
          requests = {
            storage = var.storage
          }
        }
      }
    ]
  }
}


module "statefulset-service" {
  source     = "git::https://github.com/mingfang/terraform-provider-k8s.git//archetypes/statefulset-service"
  parameters = merge(local.parameters, var.overrides)
}

data "template_file" "zoo-servers" {
  count = var.replicas
  template = "server.${count.index}=${var.name}-${count.index}.${var.name}:2888:3888"
}
