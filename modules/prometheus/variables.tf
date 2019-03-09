variable "name" {}

variable "namespace" {
  default = null
}

variable "replicas" {
  default = 1
}

variable port {
  default = 9090
}

variable image {
  default = "prom/prometheus"
}

variable "annotations" {
  type    = map
  default = {}
}

variable "env" {
  type    = map
  default = {}
}

variable "storage" {}

variable "storage_class_name" {}

variable "volume_claim_template_name" {
  default = "pvc"
}

variable "overrides" {
  default = {}
}