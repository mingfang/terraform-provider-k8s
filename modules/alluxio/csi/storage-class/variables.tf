variable "name" {}

variable "alluxio_master_hostname" {}

variable "alluxio_master_port" {}

variable "alluxio_path" {
  default = null
}

variable "java_options" {
  default = null
}

variable "mount_options" {
  default = null
}

variable "_provisioner" {}