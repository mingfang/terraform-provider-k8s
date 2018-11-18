resource "k8s_rbac_authorization_k8s_io_v1_role_binding" "nginx-ingress-role-nisa-binding" {
  metadata {
    labels    = "${local.labels}"
    name      = "${var.name}"
    namespace = "${k8s_core_v1_namespace.ingress-nginx.metadata.0.name}"
  }

  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "Role"
    name      = "${k8s_rbac_authorization_k8s_io_v1_role.nginx-ingress-role.metadata.0.name}"
  }

  subjects = [
    {
      kind      = "ServiceAccount"
      name      = "${k8s_core_v1_service_account.nginx-ingress-serviceaccount.metadata.0.name}"
      namespace = "${k8s_core_v1_namespace.ingress-nginx.metadata.0.name}"
    },
  ]
}
