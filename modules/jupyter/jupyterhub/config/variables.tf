variable "name" {}

variable "namespace" {
  default = null
}

variable "hub_extraConfig" {
  default = {}
}

variable "singleuser_extraEnv" {
  default = {}
}

variable "singleuser_image_name" {
  default = "jupyter/datascience-notebook"
}

variable "singleuser_image_tag" {
  default = "latest"
}

variable "singleuser_profile_list" {
  default = []
}

variable "singleuser_storage_static_pvcName" {
  default = "jupyter-users"
}