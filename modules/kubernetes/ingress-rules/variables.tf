variable "name" {}

variable "namespace" {
  default = null
}

variable "ingress_class" {
  default = null
}

variable "rules" {}

variable "overrides" {
  default = {}
}