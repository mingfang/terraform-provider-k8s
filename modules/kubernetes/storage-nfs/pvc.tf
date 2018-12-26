resource "k8s_core_v1_persistent_volume_claim" "this" {
  count = "${k8s_core_v1_persistent_volume.this.count}"

  metadata {
    name        = "${element(k8s_core_v1_persistent_volume.this.*.metadata.0.name, count.index)}"
    namespace   = "${var.namespace}"
    annotations = "${merge(var.annotations, map("pv-uid", element(k8s_core_v1_persistent_volume.this.*.metadata.0.uid, count.index)))}"
  }

  spec {
    storage_class_name = "${element(k8s_core_v1_persistent_volume.this.*.spec.0.storage_class_name, count.index)}"
    volume_name        = "${element(k8s_core_v1_persistent_volume.this.*.metadata.0.name, count.index)}"
    access_modes       = ["ReadWriteOnce"]

    resources {
      requests {
        storage = "${element(k8s_core_v1_persistent_volume.this.*.spec.0.capacity.storage, count.index)}"
      }
    }
  }

  lifecycle {
    ignore_changes = ["metadata.0.annotations"]
  }
}
