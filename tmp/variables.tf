variable "name" {
  default = "eclipse-che"
}

variable "namespace" {
  default = "eclipse-che"
}

variable "replicas" {
  default = 1
}

variable ports {
  default = [
    {
      name = "http"
      port = 8080
    },
    {
      name = "http-debug"
      port = 8000
    },
    {
      name = "jgroups-ping"
      port = 8888
    },
    {
      name = "http-metrics"
      port = 8087
    }
  ]
}

variable "image" {
  default = "eclipse/che-server:nightly"
}

variable "env" {
  type    = list
  default = []
}

variable "annotations" {
  type    = map
  default = null
}

variable "node_selector" {
  type    = map
  default = null
}

variable "storage" {
  default = "1Gi"
}

variable "storage_class_name" {
  default = "changeme"
}

variable "volume_claim_template_name" {
  default = "pvc"
}

variable "overrides" {
  default = {}
}
