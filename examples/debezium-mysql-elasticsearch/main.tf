/**
 * Use Debezium and Kafka Connect to sync from MySql to Elasticsearch.
 *
 * Based on https://github.com/debezium/debezium-examples/tree/master/unwrap-smt
 *
 * Ingress:\
 * You must set the ingress_host variable to the IP address of any node.\
 * The default will most likely not match yours.
 *
 * Storage:\
 * The [nfs-server-empty-dir](https://github.com/mingfang/terraform-provider-k8s/tree/master/modules/nfs-server-empty-dir) module
 * is used for temporary storage, making the example easy to run and clean up.
 *
 * Instructions:
 * 1. Create alias to run Terraform with this Kubernetes plugin.
 *    ```
 *    alias tf='docker run -v `pwd`/kubeconfig:/kubeconfig -v `pwd`:/docker -w /docker --rm -it
 *    ```
 * 2. Copy the kubeconfig file for your cluster to the current directory.
 * 3. Create a Terraform file to include this example, like this
 *    ```
 *    module "debezium-mysql-es" {
 *      source = "git::https://github.com/mingfang/terraform-provider-k8s.git//examples/debezium-mysql-elasticsearch"
 *      ingress_host = "<IP of any node, e.g. 192.168.2.146>"
 *    }
 *
 *    output "urls" {
 *      value = "${module.debezium-mysql-es.urls}"
 *    }
 *    ```
 * 4. Run init to download the modules.
 *    ```
 *    tf init
 *    ```
 * 5. Run apply
 *    ```
 *    tf apply
 *    ```
 * 6. The output includes a list of URLs that can be used to access Kafka and Elasticsearch.
 *    ```
 *    Outputs:
 *
 *    urls = [
 *        http://kafka-connect-ui.192.168.2.146.xip.io:30000,
 *        http://kafka-topic-ui.192.168.2.146.xip.io:30000,
 *        http://elasticsearch.192.168.2.146.xip.io:30000
 *    ]
 *    ```
 * 7. After a couple of minutes, you should see customer data sync from MySql to Elasticsearch.
 *    ```
 *    curl <Elasticsearch URL>/customers/_search?pretty
 *    ```
 * 8. Run destory to clean up.
 *    ```
 *    tf destroy
 *    ```
*/

variable "name" {
  default = "debezium-mysql-es"
}

//comma separated list of tables to sync
variable "topics" {
  default = "customers"
}

//The IP address of any node
variable "ingress_host" {
  default = "192.168.2.146"
}

module "nfs-server" {
  source = "git::https://github.com/mingfang/terraform-provider-k8s.git//modules/nfs-server-empty-dir"
  name   = "nfs-server"
}

locals {
  mount_options = [
    "nfsvers=4.2",
    "proto=tcp",
    "port=2049",
  ]
}

module "zookeeper_storage" {
  source  = "git::https://github.com/mingfang/terraform-provider-k8s.git//modules/kubernetes/nfs-storage"
  name    = "${var.name}-zookeeper"
  count   = 3
  storage = "1Gi"

  annotations {
    "nfs-server-uid" = "${module.nfs-server.deployment_uid}"
  }

  nfs_server    = "${module.nfs-server.cluster_ip}"
  mount_options = "${local.mount_options}"
}

module "kafka_storage" {
  source  = "git::https://github.com/mingfang/terraform-provider-k8s.git//modules/kubernetes/nfs-storage"
  name    = "${var.name}-kafka"
  count   = 3
  storage = "1Gi"

  annotations {
    "nfs-server-uid" = "${module.nfs-server.deployment_uid}"
  }

  nfs_server    = "${module.nfs-server.cluster_ip}"
  mount_options = "${local.mount_options}"
}

module "elasticsearch_storage" {
  source  = "git::https://github.com/mingfang/terraform-provider-k8s.git//modules/kubernetes/nfs-storage"
  name    = "${var.name}-elasticsearch"
  count   = 3
  storage = "1Gi"

  annotations {
    "nfs-server-uid" = "${module.nfs-server.deployment_uid}"
  }

  nfs_server    = "${module.nfs-server.cluster_ip}"
  mount_options = "${local.mount_options}"
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
