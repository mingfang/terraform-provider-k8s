variable name {}

variable "debezium-version" {
  default = "0.9"
}

module "zookeeper" {
  source = "./zookeeper"
  name   = "${var.name}-zookeeper"
}

module "kafka" {
  source    = "./kafka"
  name      = "${var.name}-kafka"
  zookeeper = "${module.zookeeper.name}:2181"
}

module "kafka-rest-proxy" {
  source    = "git::https://github.com/mingfang/terraform-provider-k8s.git//modules/kafka-rest-proxy"
  name      = "${var.name}-kafka-rest-proxy"
  zookeeper = "${module.zookeeper.name}:2181"
}

module "kafka-topic-ui" {
  source           = "git::https://github.com/mingfang/terraform-provider-k8s.git//modules/kafka-topic-ui"
  name             = "${var.name}-kafka-topic-ui"
  kafka_rest_proxy = "http://${module.kafka-rest-proxy.name}:8000"

  annotations {
    "nginx" = "[{\"http\": [{\"server\": \"${var.name}-kafka-topic-ui.*\", \"paths\": [{\"path\": \"/\"}]}]}]"
  }
}

module "kafka-connect-ui" {
  source        = "git::https://github.com/mingfang/terraform-provider-k8s.git//modules/kafka-connect-ui"
  name          = "${var.name}-kafka-connect-ui"
  kafka_connect = "http://${module.kafka-connect-source.name}:8083;source,http://${module.kafka-connect-sink.name}:8083;sink"

  annotations {
    "nginx" = "[{\"http\": [{\"server\": \"${var.name}-kafka-connect-ui.*\", \"paths\": [{\"path\": \"/\"}]}]}]"
  }
}

module "kafka-connect-source" {
  source            = "git::https://github.com/mingfang/terraform-provider-k8s.git//modules/kafka-connect"
  name              = "${var.name}-connect-source"
  image             = "debezium/connect:${var.debezium-version}"
  bootstrap_servers = "${module.kafka.name}:9092"
}

module "kafka-connect-sink" {
  source            = "git::https://github.com/mingfang/terraform-provider-k8s.git//modules/kafka-connect"
  name              = "${var.name}-connect-sink"
  image             = "registry.rebelsoft.com/debezium-jdbc-es"
  bootstrap_servers = "${module.kafka.name}:9092"
}

output "kafka-bootstrap-servers" {
  value = "${module.kafka.name}:9092"
}

output "kafka-connect-source" {
  value = "${module.kafka-connect-source.name}:8083"
}

output "kafka-connect-sink" {
  value = "${module.kafka-connect-sink.name}:8083"
}
