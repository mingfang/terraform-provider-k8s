resource "k8s_core_v1_config_map" "gitlab-runner" {
  data {
    "config.toml" = <<-EOF
      concurrent = 4
      check_interval = 3
      EOF
  }

  metadata {
    name      = "${var.name}"
    namespace = "${var.namespace}"
  }
}
