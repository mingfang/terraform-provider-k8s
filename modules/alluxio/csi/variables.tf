variable "name" {
  default = "alluxio"
}
variable "namespace" {
  default = null
}
variable "image" {
  default = "registry.rebelsoft.com/alluxio-csi"
}

variable "command" {
  default = ["/usr/local/bin/alluxio-csi"]
}

variable "args" {
  default = [
    "--nodeid=$(NODE_ID)",
    "--endpoint=$(CSI_ENDPOINT)",
  ]
}

