variable "name" {}
variable "storage_class_name" {}
variable "storage" {}

variable "gitlab_root_password" {}
variable "gitlab_runners_registration_token" {}
variable "auto_devops_domain" {}
variable "gitlab_external_url" {}
variable "mattermost_external_url" {}
variable "registry_external_url" {}

variable "gitlab_runner_replicas" {
  default = 1
}

module "gitlab" {
  source             = "git::https://github.com/mingfang/terraform-provider-k8s.git//modules/gitlab"
  name               = "${var.name}"
  storage_class_name = "${var.storage_class_name}"
  storage            = "${var.storage}"

  gitlab_root_password              = "${var.gitlab_root_password}"
  auto_devops_domain                = "${var.auto_devops_domain}"
  gitlab_runners_registration_token = "${var.gitlab_runners_registration_token}"
  gitlab_external_url               = "${var.gitlab_external_url}"
  mattermost_external_url           = "${var.mattermost_external_url}"
  registry_external_url             = "${var.registry_external_url}"
}

module "gitlab-runner" {
  source   = "git::https://github.com/mingfang/terraform-provider-k8s.git//modules/gitlab-runner"
  name     = "${var.name}-runner"
  replicas = "${var.gitlab_runner_replicas}"

  registration_token = "${var.gitlab_runners_registration_token}"
  gitlab_url         = "${var.gitlab_external_url}"
}

output "gitlab_external_url" {
  value = "${var.gitlab_external_url}"
}

output "mattermost_external_url" {
  value = "${var.mattermost_external_url}"
}
