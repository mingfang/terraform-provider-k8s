variable "name" {}

variable "namespace" {
  default = "default"
}

variable "replicas" {
  default = 1
}

variable image {
  default = "apachepulsar/pulsar-all:2.2.0"
}

variable "node_selector" {
  type    = "map"
  default = {}
}

locals {
  labels = {
    app     = "${var.name}"
    name    = "${var.name}"
    service = "${var.name}"
  }
}

resource "k8s_core_v1_service" "apache-pulsar" {
  metadata {
    name      = "${var.name}"
    namespace = "${var.namespace}"
    labels    = "${local.labels}"
  }

  spec {
    ports = [
      {
        name = "pulsar"
        port = 6650
      },
      {
        name = "http-admin"
        port = 8080
      },
    ]

    selector = "${local.labels}"
  }
}

resource "k8s_apps_v1_deployment" "apache-pulsar" {
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
            name  = "pulsar"
            image = "${var.image}"

            command = [
              "bin/pulsar",
              "standalone",
            ]

            resources {}
          },
        ]

        security_context {}
      }
    }
  }
}
