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
    replicas  = var.replicas
    ports = var.ports
    enable_service_links = false
    containers = [
      {
        name  = "alluxio"
        image = var.image
        args = [
          "master"
        ]
        env = concat([
          {
            name = "ALLUXIO_MASTER_PORT"
            value = var.ports.0.port
          },
        ], var.env)
      }
    ]
  }
}


module "deployment-service" {
  source     = "git::https://github.com/mingfang/terraform-provider-k8s.git//archetypes/deployment-service"
  parameters = merge(local.parameters, var.overrides)
}
