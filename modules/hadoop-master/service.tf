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
        name = "http-namenode"
        port = "${var.port_namenode_http}"
      },
      {
        name = "tcp-namenode"
        port = "${var.port_namenode_ipc}"
      },
      {
        name = "http-resourcemanager"
        port = "${var.port_resourcemanager_http}"
      },
      {
        name = "tcp-resourcemanager-ipc-0"
        port = "${var.port_resourcemanager_ipc_0}"
      },
      {
        name = "tcp-resourcemanager-ipc-1"
        port = "${var.port_resourcemanager_ipc_1}"
      },
      {
        name = "tcp-resourcemanager-ipc-2"
        port = "${var.port_resourcemanager_ipc_2}"
      },
      {
        name = "tcp-resourcemanager-ipc-3"
        port = "${var.port_resourcemanager_ipc_3}"
      },
    ]

    selector         = "${local.labels}"
    session_affinity = "${var.session_affinity}"
    type             = "${var.service_type}"
  }
}
