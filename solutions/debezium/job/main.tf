variable "name" {}

variable "command" {}

resource "k8s_batch_v1_job" "this" {
  metadata {
    name = "${var.name}"
  }

  spec {
    template {
      spec {
        containers {
          name    = "base"
          image   = "registry.rebelsoft.com/base"
          command = ["bash", "-cx", "${var.command}"]
        }

        restart_policy = "Never"
      }
    }

    backoff_limit = 4
  }
}
