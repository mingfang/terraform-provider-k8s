/**
 * go test -v test/solutions/gitlab/basic_test.go
 */

variable "name" {
  default = "test-gitlab"
}

variable "ingress_host" {
  default = "192.168.2.146"
}

variable gitlab_root_password {
  default = "changeme"
}

variable gitlab_runners_registration_token {
  default = "wMFs1-9kpfMeKsfKsNFQ"
}

variable auto_devops_domain {
  default = "1.2.3.4.nip.io"
}

module "ingress-controller" {
  source    = "../../../test/fixtures/ingress"
  name      = "${var.name}"
  namespace = "${k8s_core_v1_namespace.this.metadata.0.name}"
}

module "storage" {
  source    = "../../../test/fixtures/storage"
  name      = "${var.name}"
  namespace = "${k8s_core_v1_namespace.this.metadata.0.name}"
  count     = 1
}

module "gitlab" {
  source             = "../../../solutions/gitlab"
  name               = "${var.name}"
  namespace          = "${k8s_core_v1_namespace.this.metadata.0.name}"
  storage_class_name = "${module.storage.storage_class_name}"
  storage            = "${module.storage.storage}"

  gitlab_root_password              = "${var.gitlab_root_password}"
  auto_devops_domain                = "${var.auto_devops_domain}"
  gitlab_runners_registration_token = "${var.gitlab_runners_registration_token}"
  gitlab_external_url               = "http://${k8s_extensions_v1beta1_ingress.this.spec.0.rules.0.host}:${module.ingress-controller.node_port_http}"
  mattermost_external_url           = "http://${k8s_extensions_v1beta1_ingress.this.spec.0.rules.1.host}:${module.ingress-controller.node_port_http}"
  registry_external_url             = "http://${k8s_extensions_v1beta1_ingress.this.spec.0.rules.2.host}:${module.ingress-controller.node_port_http}"
}

resource "k8s_extensions_v1beta1_ingress" "this" {
  metadata {
    name      = "${var.name}"
    namespace = "${k8s_core_v1_namespace.this.metadata.0.name}"

    annotations {
      "kubernetes.io/ingress.class" = "${module.ingress-controller.ingress_class}"
    }
  }

  spec {
    rules = [
      {
        host = "${var.name}.${var.ingress_host}.nip.io"

        http {
          paths = [
            {
              path = "/"

              backend {
                service_name = "${var.name}"
                service_port = 80
              }
            },
          ]
        }
      },
      {
        host = "mattermost.${var.name}.${var.ingress_host}.nip.io"

        http {
          paths = [
            {
              path = "/"

              backend {
                service_name = "${var.name}"
                service_port = 80
              }
            },
          ]
        }
      },
      {
        host = "registry.${var.name}.${var.ingress_host}.nip.io"

        http {
          paths = [
            {
              path = "/"

              backend {
                service_name = "${var.name}"
                service_port = 80
              }
            },
          ]
        }
      },
    ]
  }
}

output "gitlab_url" {
  value = "${module.gitlab.gitlab_external_url}"
}
