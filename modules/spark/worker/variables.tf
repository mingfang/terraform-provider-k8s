variable "name" {}

variable "namespace" {
  default = null
}

variable "env" {
  default = []
}

variable "replicas" {
  default = 1
}

variable "image" {
  default = "registry.rebelsoft.com/spark"
}

variable "overrides" {
  default = {}
}

variable "master_url" {}

variable "spark_worker_webui_port" {
  default = 8081
}