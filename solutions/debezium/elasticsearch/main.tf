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
  default = "docker.elastic.co/elasticsearch/elasticsearch:5.5.2"
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

/*
service
*/

resource "k8s_core_v1_service" "elasticsearch" {
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
        name = "http"
        port = 9200
      },
    ]
  }
}

/*
statefulset
*/

resource "k8s_apps_v1_stateful_set" "elasticsearch" {
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
            name  = "elasticsearch"
            image = "${var.image}"

            env = [
              {
                name  = "http.host"
                value = "0.0.0.0"
              },
              {
                name  = "transport.host"
                value = "127.0.0.1"
              },
              {
                name  = "xpack.security.enabled"
                value = "false"
              },
              {
                name  = "ES_JAVA_OPTS"
                value = "-Xms512m -Xmx512m"
              },
            ]
          },
        ]
      }
    }
  }
}

output "name" {
  value = "${k8s_core_v1_service.elasticsearch.metadata.0.name}"
}
