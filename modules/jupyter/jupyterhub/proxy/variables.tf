variable "name" {}

variable "namespace" {
  default = null
}

variable "annotations" {
  default = null
}

variable "replicas" {
  default = 1
}

variable "port" {
  default = 8000
}

variable "image" {
  default = "jupyterhub/configurable-http-proxy:latest"
}

variable "overrides" {
  default = {}
}

variable "secret_name" {}
variable "hub_service_host" {}
variable "hub_service_port" {}