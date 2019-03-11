variable "name" {}

variable "namespace" {
  default = null
}

variable "replicas" {
  default = 1
}

variable ports {
  type = list
  default = [
    {
      name = "tcp"
      port = 3306
    },
  ]
}

variable image {
  default = "mysql"
}

variable "env" {
  type = list
  default = [
    {
      name  = "REGISTRY_STORAGE_DELETE_ENABLED"
      value = "true"
    },
  ]
}

variable "annotations" {
  type    = map
  default = {}
}

variable "node_selector" {
  type    = map
  default = {}
}

variable "storage" {}

variable "storage_class_name" {}

variable "volume_claim_template_name" {
  default = "pvc"
}

variable "overrides" {
  default = {}
}

variable mysql_user {}

variable mysql_password {}

variable mysql_database {}

variable "mysql_root_password" {}
