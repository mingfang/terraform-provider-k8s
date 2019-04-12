variable "name" {}

variable "namespace" {
  default = null
}

variable "replicas" {
  default = 1
}

variable "port" {
  default = 8000
}

variable "image" {
  default = "jupyterhub/configurable-http-proxy:3.0.0"
}

variable "overrides" {
  default = {}
}

variable "secret_name" {}
variable "hub_service_host" {}
variable "hub_service_port" {}