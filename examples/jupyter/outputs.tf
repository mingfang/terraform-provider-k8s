output "preload_images" {
  value = local.preload_images
}

output "urls" {
  value = [
    "http://${module.ingress-rules.rules.0.host}:${var.ingress_node_port}",
  ]
}
