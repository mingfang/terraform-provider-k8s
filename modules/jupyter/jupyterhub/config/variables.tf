variable "name" {}

variable "namespace" {
  default = null
}

variable "singleuser_image_name" {
  default = "jupyter/datascience-notebook"
}

variable "singleuser_image_tag" {
  default = "latest"
}

variable "singleuser_storage_static_pvcName" {
  default = "jupyter-users"
}