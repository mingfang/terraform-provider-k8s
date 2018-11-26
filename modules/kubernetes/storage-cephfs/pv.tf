resource "k8s_core_v1_persistent_volume" "this" {
  count = "${var.count}"

  metadata {
    name        = "pvc-${var.name}-${count.index}"
    annotations = "${var.annotations}"
  }

  spec {
    storage_class_name               = "${var.name}"
    persistent_volume_reclaim_policy = "Retain"
    access_modes                     = ["ReadWriteOnce"]

    capacity {
      storage = "${var.storage}"
    }

    cephfs {
      user     = "${var.user}"
      monitors = "${var.monitors}"
      path     = "${var.path}"

      secret_ref {
        name      = "${var.secret_name}"
        namespace = "${var.secret_namespace}"
      }
    }

    mount_options = "${var.mount_options}"
  }

  lifecycle {
    ignore_changes = ["metadata.0.annotations"]
  }
}
