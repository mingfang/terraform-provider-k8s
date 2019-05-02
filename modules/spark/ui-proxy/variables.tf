variable "name" {}

variable "namespace" {
  default = null
}

variable "image" {
  default = "elsonrodriguez/spark-ui-proxy:1.0"
}

variable "overrides" {
  default = {}
}

variable "master_host" {}

variable "master_port" {}
