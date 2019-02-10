/**
 * Module usage:
 *
 *     module "zookeeper" {
 *       source             = "git::https://github.com/mingfang/terraform-provider-k8s.git//modules/zookeeper"
 *       name               = "test-zookeeper"
 *       storage_class_name = "test-zookeeper"
 *       storage            = "100Gi"
 *       replicas           = "${k8s_core_v1_persistent_volume.test-zookeeper.count}"
 *     }
 *
 *     resource "k8s_core_v1_persistent_volume" "test-zookeeper" {
 *       count = 3
 *
 *       metadata {
 *         name = "pvc-test-zookeeper-${count.index}"
 *       }
 *
 *       spec {
 *         storage_class_name               = "test-zookeeper"
 *         persistent_volume_reclaim_policy = "Retain"
 *         access_modes                     = ["ReadWriteOnce"]
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
 *             name      = "ceph-secret"
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
  default = "zookeeper"
}

variable ports {
  type = "list"

  default = [
    {
      name = "client"
      port = 2181
    },
    {
      name = "server"
      port = 2888
    },
    {
      name = "leader-election"
      port = 3888
    },
  ]
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

output "ports" {
  value = "${k8s_core_v1_service.this.spec.0.ports}"
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
