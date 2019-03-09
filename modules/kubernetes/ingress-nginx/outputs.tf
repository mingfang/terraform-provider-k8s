output "name" {
  value = module.deployment-service.service.metadata.0.name
}

output "port" {
  value = module.deployment-service.service.spec.0.ports.0.port
}

output "cluster_ip" {
  value = module.deployment-service.service.spec.0.cluster_ip
}


output "annotations_prefix" {
  value = "${var.annotations_prefix}"
}

output "ingress_class" {
  value = "${var.ingress_class}"
}

output "node_port_http" {
  value = module.deployment-service.service.spec.0.ports.0.node_port
}

output "node_port_https" {
  value = module.deployment-service.service.spec.0.ports.1.node_port
}
