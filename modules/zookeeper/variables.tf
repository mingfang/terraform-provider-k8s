variable "name" {}

variable "namespace" {
  default = null
}

variable "replicas" {
  default = 1
}

variable ports {
  default = [
    {
      name = "client"
      port = 2181
    },
    {
      name = "server"
      port = 2888
    },
    {
      name = "leader-election"
      port = 3888
    },
  ]
}

variable "image" {
  default = "zookeeper"
}

variable "env" {
  type    = list
  default = []
}

variable "annotations" {
  type    = map
  default = null
}

variable "node_selector" {
  type    = map
  default = null
}

variable "storage" {}

variable "storage_class_name" {}

variable "volume_claim_template_name" {
  default = "pvc"
}

variable "overrides" {
  default = {}
}