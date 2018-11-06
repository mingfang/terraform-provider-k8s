/**
 * Use Debezium and Kafka Connect to sync from Mysql to Elasticsearch.
 *
 * Based on https://github.com/debezium/debezium-examples/tree/master/unwrap-smt
*/

variable "debezium-version" {
  default = "0.9"
}

module "zookeeper" {
  source = "./zookeeper"
}

module "kafka" {
  source    = "./kafka"
  zookeeper = "${module.zookeeper.name}"
}

/*
Data source
*/

module "mysql" {
  source              = "./mysql"
  name                = "debezium-mysql"
  mysql_root_password = "debezium"
  mysql_user          = "mysqluser"
  mysql_password      = "mysqlpw"
}

/*
Kafka Connect For Source
*/

module "kafka-connect-source" {
  source            = "./kafka-connect"
  name              = "debezium-connect-source"
  image             = "debezium/connect:${var.debezium-version}"
  bootstrap_servers = "${module.kafka.name}:9092"
}

/*
Data sink
*/

module "elasticsearch" {
  source = "./elasticsearch"
}

/*
Kafka Connect For Sink
*/

module "kafka-connect-sink" {
  source            = "./kafka-connect"
  name              = "debezium-connect-sink"
  image             = "registry.rebelsoft.com/debezium-jdbc-es"
  bootstrap_servers = "${module.kafka.name}:9092"
}

/*
Job to configure source
*/

data "template_file" "source" {
  template = "${file("${path.module}/source.json")}"

  vars {
    name                                     = "inventory-connector"
    database.hostname                        = "${module.mysql.name}"
    database.port                            = "3306"
    database.user                            = "root"
    database.password                        = "debezium"
    database.server.id                       = "184054"
    database.server.name                     = "dbserver1"
    database.whitelist                       = "inventory"
    database.history.kafka.bootstrap.servers = "${module.kafka.name}:9092"
    database.history.kafka.topic             = "schema-changes.inventory"
  }
}

module "job_source" {
  source = "./job"
  name   = "debezium-source-init"

  command = <<EOF
    until curl -s -H 'Accept:application/json' ${module.kafka-connect-source.name}:8083/
    do echo 'Waiting for Kafka Connect...'; sleep 10; done
    curl -s -X DELETE ${module.kafka-connect-source.name}:8083/connectors/${data.template_file.source.vars.name}
    curl -s -i -X POST -H 'Accept:application/json' -H 'Content-Type:application/json' \
      ${module.kafka-connect-source.name}:8083/connectors/ -d '${data.template_file.source.rendered}'
EOF
}

/*
Job to configure sink
*/

data "template_file" "sink" {
  template = "${file("${path.module}/sink.json")}"

  vars {
    name           = "elastic-sink"
    topic          = "customers"
    connection.url = "http://${module.elasticsearch.name}:9200"
  }
}

module "job_sink" {
  source = "./job"
  name   = "debezium-sink-init"

  command = <<EOF
    until curl -s -H 'Accept:application/json' ${module.kafka-connect-sink.name}:8083/
    do echo 'Waiting for Kafka Connect...'; sleep 10; done
    curl -s -X DELETE ${module.kafka-connect-sink.name}:8083/connectors/${data.template_file.sink.vars.name}
    curl -s -i -X POST -H 'Accept:application/json' -H 'Content-Type:application/json' \
      ${module.kafka-connect-sink.name}:8083/connectors/ -d '${data.template_file.sink.rendered}'
EOF
}
