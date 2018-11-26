resource "k8s_rbac_authorization_k8s_io_v1_role_binding" "this" {
  metadata {
    labels    = "${local.labels}"
    name      = "${var.name}"
    namespace = "${var.namespace}"
  }

  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "Role"
    name      = "${k8s_rbac_authorization_k8s_io_v1_role.this.metadata.0.name}"
  }

  subjects = [
    {
      kind      = "ServiceAccount"
      name      = "${k8s_core_v1_service_account.this.metadata.0.name}"
      namespace = "${var.namespace}"
    },
  ]
}
