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
  default = "landoop/kafka-topics-ui"
}

variable "annotations" {
  type    = "map"
  default = {}
}

variable "node_selector" {
  type    = "map"
  default = {}
}

/*
service specific variables
*/

variable kafka_rest_proxy {}

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
    name        = "${var.name}"
    namespace   = "${var.namespace}"
    labels      = "${local.labels}"
    annotations = "${var.annotations}"
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
            name  = "kafka-topic-ui"
            image = "${var.image}"

            env = [
              {
                name  = "KAFKA_REST_PROXY_URL"
                value = "${var.kafka_rest_proxy}"
              },
              {
                name  = "PROXY"
                value = "true"
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
