variable "name" {}

variable "namespace" {
  default = null
}

variable "replicas" {
  default = 3
}

variable ports {
  default = [
    {
      name = "peer"
      port = 2380
    },
    {
      name = "client"
      port = 2379
    },
  ]
}

variable "image" {
  default = "gcr.io/etcd-development/etcd:v3.3.12"
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