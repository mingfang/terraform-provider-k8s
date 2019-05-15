resource "k8s_apps_v1_daemon_set" "speaker" {
  metadata {
    labels = {
      "app"       = "metallb"
      "component" = "speaker"
    }
    name      = "speaker"
    namespace = var.namespace
  }
  spec {
    selector {
      match_labels = {
        "app"       = "metallb"
        "component" = "speaker"
      }
    }
    template {
      metadata {
        annotations = {
          "prometheus.io/port"   = "7472"
          "prometheus.io/scrape" = "true"
        }
        labels = {
          "app"       = "metallb"
          "component" = "speaker"
        }
      }
      spec {

        containers {
          args = [
            "--port=7472",
            "--config=config",
          ]

          env {
            name = "METALLB_NODE_NAME"
            value_from {
              field_ref {
                field_path = "spec.nodeName"
              }
            }
          }
          image             = "metallb/speaker:v0.7.3"
          image_pull_policy = "IfNotPresent"
          name              = "speaker"

          ports {
            container_port = 7472
            name           = "monitoring"
          }
          resources {
            limits = {
              "cpu"    = "100m"
              "memory" = "100Mi"
            }
          }
          security_context {
            allow_privilege_escalation = false
            capabilities {
              add = [
                "net_raw",
              ]
              drop = [
                "all",
              ]
            }
            read_only_root_filesystem = true
          }
        }
        host_network                     = true
        service_account_name             = "speaker"
        termination_grace_period_seconds = 0
      }
    }
  }
}