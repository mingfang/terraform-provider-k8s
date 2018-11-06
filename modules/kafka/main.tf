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

variable image {
  default = "confluentinc/cp-kafka:5.0.0"
}

variable "node_selector" {
  type    = "map"
  default = {}
}

/*
statefulset specific
*/

variable storage_class_name {}

variable storage {}

variable volume_claim_template_name {
  default = "pvc"
}

/*
service specific variables
*/

variable "kafka_zookeeper_connect" {}

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
        port = 9092
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
            name  = "kafka"
            image = "${var.image}"

            env = [
              {
                name = "POD_NAME"

                value_from {
                  field_ref {
                    field_path = "metadata.name"
                  }
                }
              },
              {
                name  = "KAFKA_LOG_DIRS"
                value = "/data/$(POD_NAME)"
              },
              {
                name  = "KAFKA_ADVERTISED_LISTENERS"
                value = "PLAINTEXT://$(POD_NAME).${var.name}.${var.namespace}.svc.cluster.local:9092"
              },
              {
                name  = "KAFKA_ZOOKEEPER_CONNECT"
                value = "${var.kafka_zookeeper_connect}"
              },
            ]

            volume_mounts {
              name       = "${var.volume_claim_template_name}"
              mount_path = "/data"
              sub_path   = "${var.name}"
            }
          },
        ]
      }
    }

    volume_claim_templates {
      metadata {
        name = "${var.volume_claim_template_name}"
      }

      spec {
        storage_class_name = "${var.storage_class_name}"
        access_modes       = ["ReadWriteOnce"]

        resources {
          requests {
            storage = "${var.storage}"
          }
        }
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
