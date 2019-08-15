variable "name" {}

variable "namespace" {
  default = null
}

/*
First replicas will be coordinator only.
The other replicas will be workers.
*/
variable "replicas" {
  default = 2
}

variable "ports" {
  default = [
    {
      name : "http"
      port : 8081
    },
  ]
}

variable "image" {
  default = "apachepulsar/pulsar-all:latest"
}

variable "overrides" {
  default = {}
}

variable memory {
  default = "-Xms64m -Xmx128m -XX:MaxDirectMemorySize=128m"
}

variable "pulsar" {}

variable "zookeeper" {}

variable "EXTRA_OPTS" {
  default = ""
}
