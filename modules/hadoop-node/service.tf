resource "k8s_core_v1_service" "this" {
  metadata {
    annotations = "${var.annotations}"
    labels      = "${local.labels}"
    name        = "${var.name}"
    namespace   = "${var.namespace}"
  }

  spec {
    ports = [
      {
        name = "http-datanode"
        port = "${var.port_datanode_http}"
      },
      {
        name = "tcp-datanode-ipc"
        port = "${var.port_datanode_ipc}"
      },
      {
        name = "tcp-datanode-stream"
        port = "${var.port_datanode_stream}"
      },
      {
        name = "http-resourcenode"
        port = "${var.port_resourcenode_http}"
      },
    ]

    selector         = "${local.labels}"
    session_affinity = "${var.session_affinity}"
    type             = "${var.service_type}"
  }
}
