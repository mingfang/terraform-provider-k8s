
locals {
  parameters = {
    name          = var.name
    namespace     = var.namespace
    annotations   = var.annotations
    node_selector = var.node_selector
    replicas      = var.replicas
    ports         = var.ports
    containers = [
      {
        name  = "mysql"
        image = var.image
        env = concat([
          {
            name  = "MYSQL_USER"
            value = var.mysql_user
          },
          {
            name  = "MYSQL_PASSWORD"
            value = var.mysql_password
          },
          {
            name  = "MYSQL_DATABASE"
            value = var.mysql_database
          },
          {
            name  = "MYSQL_ROOT_PASSWORD"
            value = var.mysql_root_password
          },
          {
            name  = "TZ"
            value = "UTC"
          },
        ], var.env)

        volume_mounts = [
          {
            name       = var.volume_claim_template_name
            mount_path = "/var/lib/mysql"
            sub_path   = var.name
          },
        ]
      },
    ]
    volume_claim_templates = [
      {
        name               = var.volume_claim_template_name
        storage_class_name = var.storage_class_name
        access_modes       = ["ReadWriteOnce"]

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
