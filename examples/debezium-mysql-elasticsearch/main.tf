/**
 * Use Debezium and Kafka Connect to sync from Mysql to Elasticsearch.
 *
 * Based on https://github.com/debezium/debezium-examples/tree/master/unwrap-smt
 *
 * Requirements: You must change the storage module to match your environment
*/

variable "name" {
  default = "debezium-mysql-es"
}

variable "topics" {
  default = "customers"
}

module "zookeeper_storage" {
  source = "./storage"
  name   = "${var.name}-zookeeper"
  count  = 3
}

module "kafka_storage" {
  source = "./storage"
  name   = "${var.name}-kafka"
  count  = 3
}

module "elasticsearch_storage" {
  source = "./storage"
  name   = "${var.name}-elasticsearch"
  count  = 3
}

module "mysql" {
  source = "./mysql"
  name   = "${var.name}-mysql"
}

module "elasticsearch" {
  source             = "git::https://github.com/mingfang/terraform-provider-k8s.git//modules/elasticsearch"
  name               = "${var.name}-elasticsearch"
  storage_class_name = "${module.elasticsearch_storage.storage_class_name}"
  storage            = "${module.elasticsearch_storage.storage}"
  replicas           = "${module.elasticsearch_storage.count}"
}

module "debezium" {
  source                  = "git::https://github.com/mingfang/terraform-provider-k8s.git//solutions/debezium"
  name                    = "${var.name}"
  zookeeper_storage_class = "${module.zookeeper_storage.storage_class_name}"
  zookeeper_storage       = "${module.zookeeper_storage.storage}"
  zookeeper_count         = "${module.zookeeper_storage.count}"
  kafka_storage_class     = "${module.kafka_storage.storage_class_name}"
  kafka_storage           = "${module.kafka_storage.storage}"
  kafka_count             = "${module.kafka_storage.count}"
}

data "template_file" "source" {
  template = "${file("${path.module}/source.json")}"

  vars {
    name                                     = "${var.name}-source-connector"
    database.hostname                        = "${module.mysql.name}"
    database.port                            = "${module.mysql.port}"
    database.user                            = "root"
    database.password                        = "debezium"
    database.server.id                       = "184054"
    database.server.name                     = "dbserver1"
    database.whitelist                       = "inventory"
    database.history.kafka.bootstrap.servers = "${module.debezium.kafka-bootstrap-servers}"
    database.history.kafka.topic             = "${var.name}.schema-changes"
  }
}

module "job_source" {
  source = "git::https://github.com/mingfang/terraform-provider-k8s.git//solutions/debezium/job"
  name   = "${var.name}-source-init"

  kafka_connect    = "${module.debezium.kafka-connect-source}"
  connector_name   = "${module.mysql.name}"
  connector_config = "${data.template_file.source.rendered}"
}

data "template_file" "sink" {
  template = "${file("${path.module}/sink.json")}"

  vars {
    name           = "elastic-sink"
    topics         = "${var.topics}"
    topics.regex   = ""
    connection.url = "http://${module.elasticsearch.name}:9200"
  }
}

module "job_sink" {
  source = "git::https://github.com/mingfang/terraform-provider-k8s.git//solutions/debezium/job"
  name   = "${var.name}-sink-init"

  kafka_connect    = "${module.debezium.kafka-connect-sink}"
  connector_name   = "${module.elasticsearch.name}"
  connector_config = "${data.template_file.sink.rendered}"
}
