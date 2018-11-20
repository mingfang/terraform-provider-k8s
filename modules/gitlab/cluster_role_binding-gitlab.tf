resource "k8s_rbac_authorization_k8s_io_v1_cluster_role_binding" "gitlab" {
  metadata {
    name = "${var.name}"
  }

  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = "${k8s_rbac_authorization_k8s_io_v1_cluster_role.gitlab.metadata.0.name}"
  }

  subjects = [
    {
      kind      = "ServiceAccount"
      name      = "${k8s_core_v1_service_account.gitlab.metadata.0.name}"
      namespace = "${k8s_core_v1_service_account.gitlab.metadata.0.namespace}"
    },
  ]
}
