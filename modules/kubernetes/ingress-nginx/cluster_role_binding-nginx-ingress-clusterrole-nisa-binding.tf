resource "k8s_rbac_authorization_k8s_io_v1_cluster_role_binding" "nginx-ingress-clusterrole-nisa-binding" {
  metadata {
    labels = "${local.labels}"
    name   = "${var.name}"
  }

  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = "${k8s_rbac_authorization_k8s_io_v1_cluster_role.nginx-ingress-clusterrole.metadata.0.name}"
  }

  subjects = [
    {
      kind      = "ServiceAccount"
      name      = "${k8s_core_v1_service_account.nginx-ingress-serviceaccount.metadata.0.name}"
      namespace = "${k8s_core_v1_namespace.ingress-nginx.metadata.0.name}"
    },
  ]
}
