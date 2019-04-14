output "urls" {
  value = [
    "http://${module.ingress-rules.rules.0.host}:${var.ingress-node-port}",
  ]
}

output "minio_access_key" {
  value = var.minio_access_key
}

output "minio_secret_key" {
  value = var.minio_secret_key
}