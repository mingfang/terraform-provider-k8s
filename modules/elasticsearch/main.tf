/**
 * [Elasticsearch](https://www.elastic.co/products/elasticsearch)
 *
 * Module usage:
 *
 *     module "elasticsearch" {
 *       source             = "git::https://github.com/mingfang/terraform-provider-k8s.git//modules/elasticsearch"
 *       name               = "test-elasticsearch"
 *       storage_class_name = "test-elasticsearch"
 *       storage            = "100Gi"
 *       replicas           = "${k8s_core_v1_persistent_volume.test-elasticsearch.count}"
 *     }
 *     
 *     resource "k8s_core_v1_persistent_volume" "test-elasticsearch" {
 *       count = 3
 *     
 *       metadata {
 *         name = "pvc-test-elasticsearch-${count.index}"
 *       }
 *     
 *       spec {
 *         storage_class_name               = "test-elasticsearch"
 *         persistent_volume_reclaim_policy = "Retain"
 *     
 *         access_modes = [
 *           "ReadWriteMany",
 *         ]
 *     
 *         capacity {
 *           storage = "100Gi"
 *         }
 *     
 *         cephfs {
 *           user = "admin"
 *     
 *           monitors = [
 *             "192.168.2.89",
 *             "192.168.2.39",
 *           ]
 *     
 *           secret_ref {
 *             name = "ceph-secret"
 *             namespace = "default"
 *           }
 *         }
 *       }
 *     }
 */

/*
common variables
*/

variable "name" {}

variable "namespace" {
  default = ""
}

variable "replicas" {
  default = 1
}

variable image {
  default = "docker.elastic.co/elasticsearch/elasticsearch:6.5.1"
}

variable port {
  default = 9200
}

variable "annotations" {
  type    = "map"
  default = {}
}

variable "node_selector" {
  type    = "map"
  default = {}
}

variable "dns_policy" {
  default = ""
}

variable "priority_class_name" {
  default = ""
}

variable "restart_policy" {
  default = ""
}

variable "scheduler_name" {
  default = ""
}

variable "service_account_name" {
  default = ""
}

variable "termination_grace_period_seconds" {
  default = 30
}

variable "session_affinity" {
  default = ""
}

variable "service_type" {
  default = ""
}

/*
service specific variables
*/

variable "heap_size" {
  default = "4g"
}

/*
locals
*/

locals {
  labels {
    app     = "${var.name}"
    name    = "${var.name}"
    service = "${var.name}"
  }
}

/*
output
*/

output "name" {
  value = "${k8s_core_v1_service.this.metadata.0.name}"
}

output "port" {
  value = "${k8s_core_v1_service.this.spec.0.ports.0.port}"
}

output "cluster_ip" {
  value = "${k8s_core_v1_service.this.spec.0.cluster_ip}"
}

output "statefulset_uid" {
  value = "${k8s_apps_v1_stateful_set.this.metadata.0.uid}"
}

/*
statefulset specific
*/

variable storage_class_name {}

variable storage {}

variable volume_claim_template_name {
  default = "pvc"
}
