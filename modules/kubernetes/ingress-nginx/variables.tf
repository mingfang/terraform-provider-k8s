variable "name" {}

variable "namespace" {
  default = null
}

variable "service_type" {
  default = "NodePort"
}

variable "ingress_class" {
  default = "nginx"
}

variable "load_balancer_ip" {
  default = null
}

variable "node_port_http" {
  default = 30000
}

variable "node_port_https" {
  default = 30443
}

variable "extra_args" {
  type    = list
  default = []
}

variable "tcp_services_data" {
  default = {}
}