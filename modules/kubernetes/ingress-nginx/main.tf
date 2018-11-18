/**
 * Based on https://github.com/kubernetes/ingress-nginx/blob/master/deploy/mandatory.yaml
 */

variable "name" {
  default = "ingress-nginx"
}

variable "namespace" {
  default = "ingress-nginx"
}

variable "replicas" {
  default = 1
}

variable image {
  default = "quay.io/kubernetes-ingress-controller/nginx-ingress-controller:0.20.0"
}

variable "node_selector" {
  type    = "map"
  default = {}
}

variable "node_port_http" {
  default = 30000
}

variable "node_port_https" {
  default = 30443
}

locals {
  labels {
    "app.kubernetes.io/name"    = "${var.name}"
    "app.kubernetes.io/part-of" = "${var.name}"
  }
}
