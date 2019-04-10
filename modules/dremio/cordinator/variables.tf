variable "name" {}

variable "namespace" {
  default = null
}

variable "annotations" {
  type    = map
  default = {}
}

variable "env" {
  type    = list
  default = []
}

variable "image" {
  default = "dremio/dremio-oss:latest"
}

variable "node_selector" {
  type    = map
  default = null
}

variable "replicas" {
  default = 1
}

variable "overrides" {
  default = {}
}

variable "config_map" {}

variable "master-cordinator" {}

variable "zookeeper" {}
