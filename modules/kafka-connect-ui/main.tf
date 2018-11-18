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
  default = "landoop/kafka-connect-ui"
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

variable kafka_connect {}

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

/*
deployment
*/

output "name" {
  value = "${k8s_core_v1_service.this.metadata.0.name}"
}
