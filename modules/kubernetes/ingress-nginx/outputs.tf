output "service" {
  value = k8s_core_v1_service.ingress-nginx
}

output "deployment" {
  value = k8s_apps_v1_deployment.nginx-ingress-controller
}

output "ingress_class" {
  value = var.ingress_class
}

output "node_port_http" {
  value = k8s_core_v1_service.ingress-nginx.spec.0.ports.0.node_port
}

output "node_port_https" {
  value = k8s_core_v1_service.ingress-nginx.spec.0.ports.1.node_port
}