variable "name" {
  default = "ingress-nginx"
}

variable "namespace" {
  default = null
}

variable "replicas" {
  default = 1
}

variable image {
  default = "quay.io/kubernetes-ingress-controller/nginx-ingress-controller:0.21.0"
}

variable port {
  default = 80
}


variable "service_type" {
  default = "NodePort"
}


variable "annotations_prefix" {
  default = "nginx.ingress.kubernetes.io"
}

variable "ingress_class" {
  default = "nginx"
}

variable "node_port_http" {
  default = 30000
}

variable "node_port_https" {
  default = 30443
}

variable "overrides" {
  default = {}
}
