/**
 * [Nginx Ingress Controller](https://kubernetes.github.io/ingress-nginx/)
 *
 * Based on https://github.com/kubernetes/ingress-nginx/blob/master/deploy/mandatory.yaml
 */

locals {
  parameters = {
    name      = var.name
    namespace = var.namespace
    replicas  = var.replicas
    ports = [
      {
        name        = "http"
        protocol    = "TCP"
        port        = var.port
        target_port = 80
        node_port   = var.node_port_http
      },
      {
        name        = "https"
        protocol    = "TCP"
        port        = 443
        target_port = 443
        node_port   = var.node_port_https
      },
    ]
    containers = [
      {
        name  = "nginx-ingress-controller"
        image = var.image

        args = [
          "/nginx-ingress-controller",
          "--election-id=${var.name}",
          "--ingress-class=${var.ingress_class}",
          //          "--configmap=$(POD_NAMESPACE)/${k8s_core_v1_config_map.this.metadata.0.name}",
          "--publish-service=$(POD_NAMESPACE)/${var.name}",
          "--annotations-prefix=${var.annotations_prefix}",
        ]

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
            name = "POD_NAMESPACE"

            value_from = {
              field_ref = {
                field_path = "metadata.namespace"
              }
            }
          },
        ]

        liveness_probe = {
          failure_threshold     = 3
          initial_delay_seconds = 10
          period_seconds        = 10
          success_threshold     = 1
          timeout_seconds       = 1

          http_get = {
            path   = "/healthz"
            port   = "10254"
            scheme = "HTTP"
          }
        }

        readiness_probe = {
          failure_threshold = 3
          period_seconds    = 10
          success_threshold = 1
          timeout_seconds   = 1

          http_get = {
            path   = "/healthz"
            port   = "10254"
            scheme = "HTTP"
          }
        }

        security_context = {
          capabilities = {
            add = [
              "NET_BIND_SERVICE",
            ]

            drop = [
              "ALL",
            ]
          }

          run_asuser = 33
        }
      },
    ]
    service_account_name = module.rbac.service_account.metadata.0.name
    type                 = var.service_type
  }
}


module "deployment-service" {
  source     = "git::https://github.com/mingfang/terraform-provider-k8s.git//archetypes/deployment-service"
  parameters = merge(local.parameters, var.overrides)
}

module "rbac" {
  source    = "../rbac"
  name      = var.name
  namespace = var.namespace
  cluster_role_rules = [
    {
      api_groups = [
        "",
      ]

      resources = [
        "configmaps",
        "endpoints",
        "nodes",
        "pods",
        "secrets",
      ]

      verbs = [
        "list",
        "watch",
      ]
    },
    {
      api_groups = [
        "",
      ]

      resources = [
        "nodes",
      ]

      verbs = [
        "get",
      ]
    },
    {
      api_groups = [
        "",
      ]

      resources = [
        "services",
      ]

      verbs = [
        "get",
        "list",
        "watch",
      ]
    },
    {
      api_groups = [
        "extensions",
      ]

      resources = [
        "ingresses",
      ]

      verbs = [
        "get",
        "list",
        "watch",
      ]
    },
    {
      api_groups = [
        "",
      ]

      resources = [
        "events",
      ]

      verbs = [
        "create",
        "patch",
      ]
    },
    {
      api_groups = [
        "extensions",
      ]

      resources = [
        "ingresses/status",
      ]

      verbs = [
        "update",
      ]
    },
  ]
  role_rules = [
    {
      api_groups = [
        "",
      ]

      resources = [
        "configmaps",
        "pods",
        "secrets",
        "namespaces",
      ]

      verbs = [
        "get",
      ]
    },
    {
      api_groups = [
        "",
      ]

      resource_names = [
        "k8s_core_v1_config_map.this.metadata.0.name-var.ingress_class",
      ]

      resources = [
        "configmaps",
      ]

      verbs = [
        "get",
        "update",
      ]
    },
    {
      api_groups = [
        "",
      ]

      resources = [
        "configmaps",
      ]

      verbs = [
        "create",
      ]
    },
    {
      api_groups = [
        "",
      ]

      resources = [
        "endpoints",
      ]

      verbs = [
        "get",
      ]
    },
  ]
}
