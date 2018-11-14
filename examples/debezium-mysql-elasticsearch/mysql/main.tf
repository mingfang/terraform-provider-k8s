/*
common variables
*/

variable "name" {}

variable "namespace" {
  default = "default"
}

variable "replicas" {
  default = 1
}

//this image contains example data
variable image {
  default = "debezium/example-mysql"
}

variable "node_selector" {
  type    = "map"
  default = {}
}

/*
service specific variables
*/

variable mysql_user {
  default = "mysqluser"
}

variable mysql_password {
  default = "mysqlpw"
}

variable mysql_database {
  default = ""
}

variable "mysql_root_password" {
  default = "debezium"
}

variable port {
  default = 3306
}

locals {
  labels = {
    app     = "${var.name}"
    name    = "${var.name}"
    service = "${var.name}"
  }
}

/*
service
*/

resource "k8s_core_v1_service" "this" {
  metadata {
    name      = "${var.name}"
    namespace = "${var.namespace}"
    labels    = "${local.labels}"
  }

  spec {
    selector = "${local.labels}"

    ports = [
      {
        name = "tcp"
        port = "${var.port}"
      },
    ]
  }
}

/*
statefulset
*/

resource "k8s_apps_v1_stateful_set" "this" {
  metadata {
    name      = "${var.name}"
    namespace = "${var.namespace}"
    labels    = "${local.labels}"
  }

  spec {
    replicas              = "${var.replicas}"
    service_name          = "${k8s_core_v1_service.this.metadata.0.name}"
    pod_management_policy = "OrderedReady"

    selector {
      match_labels = "${local.labels}"
    }

    update_strategy {
      type = "RollingUpdate"

      rolling_update {
        partition = 0
      }
    }

    template {
      metadata {
        labels = "${local.labels}"
      }

      spec {
        node_selector = "${var.node_selector}"

        affinity {
          pod_anti_affinity {
            required_during_scheduling_ignored_during_execution {
              label_selector {
                match_expressions {
                  key      = "app"
                  operator = "In"
                  values   = ["${var.name}"]
                }
              }

              topology_key = "kubernetes.io/hostname"
            }
          }
        }

        containers = [
          {
            name  = "mysql"
            image = "${var.image}"

            env = [
              {
                name  = "MYSQL_USER"
                value = "${var.mysql_user}"
              },
              {
                name  = "MYSQL_PASSWORD"
                value = "${var.mysql_password}"
              },
              {
                name  = "MYSQL_DATABASE"
                value = "${var.mysql_database}"
              },
              {
                name  = "MYSQL_ROOT_PASSWORD"
                value = "${var.mysql_root_password}"
              },
              {
                name  = "TZ"
                value = "UTC"
              },
              {
                name = "POD_NAME"

                value_from {
                  field_ref {
                    field_path = "metadata.name"
                  }
                }
              },
            ]

            resources {}
          },
        ]

        security_context {}
      }
    }
  }
}

resource "k8s_policy_v1beta1_pod_disruption_budget" "this" {
  metadata {
    name = "${var.name}"
  }

  spec {
    max_unavailable = 1

    selector {
      match_labels = "${local.labels}"
    }
  }
}

output "name" {
  value = "${k8s_core_v1_service.this.metadata.0.name}"
}

output "port" {
  value = "${k8s_core_v1_service.this.spec.0.ports.0.port}"
}
