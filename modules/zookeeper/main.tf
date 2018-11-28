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

variable "node_selector" {
  type    = "map"
  default = {}
}

/*
statefulset specific
*/

variable storage_class_name {}

variable storage {}

variable volume_claim_template_name {
  default = "pvc"
}

/*
service specific variables
*/

variable port {
  default = 2181
}

locals {
  labels = {
    app     = "${var.name}"
    name    = "${var.name}"
    service = "${var.name}"
  }
}

data "template_file" "zoo-servers" {
  count    = "${var.replicas}"
  template = "server.${count.index}=${var.name}-${count.index}.${var.name}:2888:3888"
}

resource "k8s_policy_v1beta1_pod_disruption_budget" "this" {
  metadata {
    name = "${var.name}"
  }

  spec {
    max_unavailable = 1

    selector {
      match_labels = "${local.labels}"
    }
  }
}

output "name" {
  value = "${k8s_core_v1_service.this.metadata.0.name}"
}

output "port" {
  value = "${k8s_core_v1_service.this.spec.0.ports.0.port}"
}
