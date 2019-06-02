variable "name" {
  default = "drools"
}

variable "namespace" {
  default = "drools"
}

resource "k8s_core_v1_namespace" "this" {
  metadata {
    labels = {
      "istio-injection" = "disabled"
    }

    name = var.namespace
  }
}

module "workbench" {
  source    = "../../modules/drools/workbench"
  name      = "workbench"
  namespace = k8s_core_v1_namespace.this.metadata[0].name
}

module "kie-server" {
  source         = "../../modules/drools/kie-server"
  name           = "kie-server"
  namespace      = k8s_core_v1_namespace.this.metadata[0].name
  replicas       = 1
  kie_server_url = "http://kie-server.rebelsoft.com/kie-server/services/rest/server"
  maven_repo_url = "http://${module.workbench.service.metadata[0].name}:${module.workbench.service.spec[0].ports[0].port}/business-central/maven2"
  controller_url = "ws://${module.workbench.service.metadata[0].name}:${module.workbench.service.spec[0].ports[0].port}/business-central/websocket/controller"
}

module "ingress-rules" {
  source        = "git::https://github.com/mingfang/terraform-provider-k8s.git//modules/kubernetes/ingress-rules"
  name          = var.name
  namespace     = k8s_core_v1_namespace.this.metadata[0].name
  ingress_class = "nginx"
  rules = [
    {
      host = "${var.name}.rebelsoft.com"

      http = {
        paths = [
          {
            path = "/"

            backend = {
              service_name = module.workbench.service.metadata[0].name
              service_port = module.workbench.service.spec[0].ports[0].port
            }
          },
        ]
      }
    },
    {
      host = "kie-server.rebelsoft.com"

      http = {
        paths = [
          {
            path = "/"

            backend = {
              service_name = module.kie-server.service.metadata[0].name
              service_port = module.kie-server.service.spec[0].ports[0].port
            }
          },
        ]
      }
    },
  ]
}
