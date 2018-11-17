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
