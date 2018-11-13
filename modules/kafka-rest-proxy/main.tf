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
  default = "confluentinc/cp-kafka-rest"
}

variable "node_selector" {
  type    = "map"
  default = {}
}

/*
service specific variables
*/

variable zookeeper {}

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
        name = "http"
        port = 8000
      },
    ]
  }
}

/*
deployment
*/

resource "k8s_apps_v1_deployment" "this" {
  metadata {
    name      = "${var.name}"
    namespace = "${var.namespace}"
    labels    = "${local.labels}"
  }

  spec {
    replicas = "${var.replicas}"

    selector {
      match_labels = "${local.labels}"
    }

    strategy {
      type = "RollingUpdate"

      rolling_update {
        max_surge       = "25%"
        max_unavailable = "25%"
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
            name  = "kafka-rest-proxy"
            image = "${var.image}"

            env = [
              {
                name  = "KAFKA_REST_ZOOKEEPER_CONNECT"
                value = "${var.zookeeper}"
              },
              {
                name  = "KAFKA_REST_HOST_NAME"
                value = "${var.name}"
              },
              {
                name  = "KAFKA_REST_LISTENERS"
                value = "http://0.0.0.0:8000"
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

output "name" {
  value = "${k8s_core_v1_service.this.metadata.0.name}"
}
