resource "k8s_rbac_authorization_k8s_io_v1_cluster_role" "this" {
  metadata {
    labels = "${local.labels}"
    name   = "${var.name}"
  }

  rules = []
}
