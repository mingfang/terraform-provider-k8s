variable "name" {}

variable "namespace" {
  default = null
}

variable "replicas" {
  default = 1
}

variable "port" {
  default = 2049
}

variable "image" {
  default = "itsthenetwork/nfs-server-alpine"
}

variable "overrides" {
  default = {}
}

//Set to Memory to use tmpfs
variable "medium" {
  default = ""
}
