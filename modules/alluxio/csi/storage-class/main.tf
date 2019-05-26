resource "k8s_storage_k8s_io_v1_storage_class" "this" {
  metadata {
    name = var.name
  }

  _provisioner = var._provisioner

  mount_options = var.mount_options
  parameters = {
    "alluxio.master.hostname" = var.alluxio_master_hostname
    "alluxio.master.port"     = var.alluxio_master_port
    "alluxio_path"            = var.alluxio_path
    "java_options"            = var.java_options
  }
}
