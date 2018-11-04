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
  default = "debezium/zookeeper"
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

resource "k8s_core_v1_service" "zookeeper" {
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
        port = 2181
      },
      {
        name = "tcp2"
        port = 2888
      },
      {
        name = "tcp3"
        port = 3888
      },
    ]
  }
}

/*
statefulset
*/

resource "k8s_apps_v1_stateful_set" "zookeeper" {
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
            name  = "zookeeper"
            image = "${var.image}"
          },
        ]
      }
    }
  }
}

output "name" {
  value = "${k8s_core_v1_service.zookeeper.metadata.0.name}"
}
