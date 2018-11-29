variable "name" {}

variable "node_port_http" {
  default = "30080"
}

variable "node_port_https" {
  default = "30081"
}

module "ingress-controller" {
  source          = "git::https://github.com/mingfang/terraform-provider-k8s.git//modules/kubernetes/ingress-nginx"
  name            = "${var.name}-ingress-controller"
  namespace       = "default"
  node_port_http  = "${var.node_port_http}"
  node_port_https = "${var.node_port_https}"
}

output "node_port_http" {
  value = "${var.node_port_http}"
}

output "node_port_https" {
  value = "${var.node_port_https}"
}
