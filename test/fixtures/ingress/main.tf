variable "name" {}

variable "namespace" {}

variable "ingress_class" {
  default = "test"
}

variable "node_port_http" {
  default = "30080"
}

variable "node_port_https" {
  default = "30081"
}

module "ingress-controller" {
  source          = "git::https://github.com/mingfang/terraform-provider-k8s.git//modules/kubernetes/ingress-nginx"
  name            = "${var.name}-ingress-controller"
  namespace       = "${var.namespace}"
  ingress_class   = "${var.ingress_class}"
  node_port_http  = "${var.node_port_http}"
  node_port_https = "${var.node_port_https}"
}

output "ingress_class" {
  value = "${module.ingress-controller.ingress_class}"
}

output "node_port_http" {
  value = "${module.ingress-controller.node_port_http}"
}

output "node_port_https" {
  value = "${module.ingress-controller.node_port_https}"
}
