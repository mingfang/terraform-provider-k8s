variable "name" {}

variable "namespace" {
  default = null
}

variable "image" {
  default = "alluxio/alluxio:2.0.0-SNAPSHOT"
}

variable "overrides" {
  default = {}
}

variable "env" {
  default = []
}

variable "alluxio_master_hostname" {}
variable "alluxio_master_port" {}