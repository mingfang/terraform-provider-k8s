resource "k8s_core_v1_service" "this" {
  metadata {
    labels    = "${local.labels}"
    name      = "${var.name}"
    namespace = "${var.namespace}"
  }

  spec {
    ports = [
      {
        name = "nfs"
        port = 2049
      },
      {
        name = "mountd"
        port = 20048
      },
      {
        name = "rpcbind"
        port = 111
      },
    ]

    selector = "${local.labels}"
  }
}
