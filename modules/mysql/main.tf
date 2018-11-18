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
  default = "mysql"
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

variable mysql_user {}

variable mysql_password {}

variable mysql_database {}

variable "mysql_root_password" {}

variable port {
  default = 3306
}

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

output "port" {
  value = "${k8s_core_v1_service.this.spec.0.ports.0.port}"
}

output "cluster_ip" {
  value = "${k8s_core_v1_service.this.spec.0.cluster_ip}"
}

output "statefulset_uid" {
  value = "${k8s_apps_v1_stateful_set.this.metadata.0.uid}"
}
