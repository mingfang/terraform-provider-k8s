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
  default = "debezium/connect"
}

variable "node_selector" {
  type    = "map"
  default = {}
}

/*
service specific variables
*/

variable bootstrap_servers {}

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

resource "k8s_core_v1_service" "connect" {
  metadata {
    name      = "${var.name}"
    namespace = "${var.namespace}"
    labels    = "${local.labels}"
  }

  spec {
    selector = "${local.labels}"

    ports = [
      {
        name = "tcp1"
        port = 8083
      },
      {
        name = "tcp2"
        port = 5005
      },
    ]
  }
}

/*
deployment
*/

resource "k8s_apps_v1_deployment" "connect" {
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
            name  = "connect"
            image = "${var.image}"

            env = [
              {
                name  = "BOOTSTRAP_SERVERS"
                value = "${var.bootstrap_servers}"
              },
              {
                name  = "GROUP_ID"
                value = "${var.name}"
              },
              {
                name  = "CONFIG_STORAGE_TOPIC"
                value = "${var.name}_connect_configs"
              },
              {
                name  = "OFFSET_STORAGE_TOPIC"
                value = "${var.name}_connect_offsets"
              },
              {
                name  = "HOST_NAME"
                value = "0.0.0.0"
              },
            ]
          },
        ]
      }
    }
  }
}

output "name" {
  value = "${k8s_core_v1_service.connect.metadata.0.name}"
}
