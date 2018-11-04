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
  default = "debezium/kafka"
}

variable "node_selector" {
  type    = "map"
  default = {}
}

/*
statefulset specific
*/

/*
service specific variables
*/

variable "zookeeper" {}

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

resource "k8s_core_v1_service" "kafka" {
  metadata {
    name      = "${var.name}"
    namespace = "${var.namespace}"
    labels    = "${local.labels}"
  }

  spec {
    cluster_ip = "None"
    selector   = "${local.labels}"

    ports = [
      {
        name = "tcp1"
        port = 9092
      },
    ]
  }
}

/*
statefulset
*/

resource "k8s_apps_v1_stateful_set" "kafka" {
  metadata {
    name      = "${var.name}"
    namespace = "${var.namespace}"
    labels    = "${local.labels}"
  }

  spec {
    replicas              = "${var.replicas}"
    service_name          = "${var.name}"
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

        containers = [
          {
            name  = "kafka"
            image = "${var.image}"

            env = [
              {
                name  = "ZOOKEEPER_CONNECT"
                value = "${var.zookeeper}"
              },
            ]
          },
        ]
      }
    }
  }
}

output "name" {
  value = "${k8s_core_v1_service.kafka.metadata.0.name}"
}
