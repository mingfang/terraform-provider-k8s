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
    ports     = var.ports
    containers = [
      {
        name  = "nifi"
        image = var.image
        env = concat([
          {
            name  = "NIFI_ELECTION_MAX_WAIT"
            value = "30 secs"
          },
          {
            name  = "NIFI_CLUSTER_NODE_PROTOCOL_PORT"
            value = "1025"
          },
          {
            name = "NIFI_CLUSTER_ADDRESS"
            value_from = {
              field_ref = {
                field_path = "status.podIP"
              }
            }
          },
          {
            name = "NIFI_WEB_HTTP_HOST"
            value_from = {
              field_ref = {
                field_path = "status.podIP"
              }
            }
          },
          {
            name = "NIFI_REMOTE_INPUT_HOST"
            value_from = {
              field_ref = {
                field_path = "status.podIP"
              }
            }
          },
        ], var.env)
      },
    ]
  }
}


module "statefulset-service" {
  source     = "git::https://github.com/mingfang/terraform-provider-k8s.git//archetypes/statefulset-service"
  parameters = merge(local.parameters, var.overrides)
}