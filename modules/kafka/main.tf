/*
common variables
*/

variable "name" {}

variable "namespace" {
  default = "default"
}

variable "replicas" {
  default = 1
}

variable image {
  default = "confluentinc/cp-kafka"
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

variable "kafka_zookeeper_connect" {}

locals {
  labels = {
    app     = "${var.name}"
    name    = "${var.name}"
    service = "${var.name}"
  }
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
