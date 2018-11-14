variable name {}

variable count {}

resource "k8s_core_v1_persistent_volume_claim" "this" {
  count = "${k8s_core_v1_persistent_volume.this.count}"

  metadata {
    name = "${element(k8s_core_v1_persistent_volume.this.*.metadata.0.name, count.index)}"
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
}

resource "k8s_core_v1_persistent_volume" "this" {
  count = "${var.count}"

  metadata {
    name = "pvc-${var.name}-${count.index}"
  }

  spec {
    storage_class_name               = "${var.name}"
    persistent_volume_reclaim_policy = "Retain"
    access_modes                     = ["ReadWriteOnce"]

    capacity {
      storage = "100Gi"
    }

    cephfs {
      user = "admin"

      monitors = [
        "192.168.2.89",
        "192.168.2.39",
      ]

      secret_ref {
        name      = "ceph-secret"
        namespace = "default"
      }
    }
  }
}

output storage_class_name {
  value = "${element(k8s_core_v1_persistent_volume_claim.this.*.spec.0.storage_class_name, 0)}"
}

output storage {
  value = "${element(k8s_core_v1_persistent_volume_claim.this.*.spec.0.resources.0.requests.storage, 0)}"
}

output count {
  value = "${k8s_core_v1_persistent_volume_claim.this.count}"
}
