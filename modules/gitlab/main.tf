/**
 * Documentation
 *
 * terraform-docs --sort-inputs-by-required --with-aggregate-type-defaults md
 *
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
  default = "gitlab/gitlab-ee:latest"
}

variable port {
  default = 80
}

variable "annotations" {
  type    = "map"
  default = {}
}

variable "node_selector" {
  type    = "map"
  default = {}
}

/*
service specific variables
*/

variable "gitlab_root_password" {}
variable "gitlab_runners_registration_token" {}
variable "auto_devops_domain" {}
variable "gitlab_external_url" {}
variable "mattermost_external_url" {}
variable "registry_external_url" {}

/*
statefulset specific
*/

variable storage_class_name {}
variable storage {}

variable volume_claim_template_name {
  default = "pvc"
}

/*
locals
*/

locals {
  gitlab_omnibus_config = <<-EOF
    external_url '${var.gitlab_external_url}';
    gitlab_rails['lfs_enabled'] = true;
    nginx['listen_port'] = 80;
    nginx['listen_https'] = false;
    mattermost_external_url '${var.mattermost_external_url}';
    mattermost_nginx['listen_port'] = 80;
    mattermost_nginx['listen_https'] = false;
    registry_external_url '${var.registry_external_url}';
    registry_nginx['listen_port'] = 80;
    registry_nginx['listen_https'] = false;
    EOF
}

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
  value = "${k8s_core_v1_service.gitlab.metadata.0.name}"
}

output "port" {
  value = "${k8s_core_v1_service.gitlab.spec.0.ports.0.port}"
}

output "cluster_ip" {
  value = "${k8s_core_v1_service.gitlab.spec.0.cluster_ip}"
}

output "statefulset_uid" {
  value = "${k8s_apps_v1_stateful_set.gitlab.metadata.0.uid}"
}

output "gitlab_runners_registration_token" {
  value = "${var.gitlab_runners_registration_token}"
}

output "gitlab_external_url" {
  value = "${var.gitlab_external_url}"
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
