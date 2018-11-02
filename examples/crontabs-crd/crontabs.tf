/**
 * Example CustomResourceDefinition
 * https://kubernetes.io/docs/tasks/access-kubernetes-api/custom-resources/custom-resource-definitions/
 */
resource "k8s_apiextensions_k8s_io_v1beta1_custom_resource_definition" "crontabs" {
  metadata {
    name = "crontabs.stable.example.com"
  }

  spec {
    group = "stable.example.com"

    versions {
      name    = "v1"
      served  = true
      storage = true
    }

    version = "v1"
    scope   = "Namespaced"

    names {
      plural    = "crontabs"
      singular  = "crontabs"
      kind      = "CronTab"

      short_names = [
        "ct",
      ]
    }

    //    validation {
    //      open_apiv3_schema {
    //        properties {
    //          spec {
    //            cron_spec {
    //              type = "string"
    //              pattern = "^(\\d+|\\*)(/\\d+)?(\\s+(\\d+|\\*)(/\\d+)?){4}$"
    //            }
    //            replicas {
    //              type = "integer"
    //              minimum = 1
    //              maximum = 10
    //            }
    //          }
    //        }
    //      }
    //    }
  }
}
