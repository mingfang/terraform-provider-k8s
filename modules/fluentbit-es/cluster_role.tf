resource "k8s_rbac_authorization_k8s_io_v1_cluster_role" "this" {
  metadata {
    name = "${var.name}"
  }

  rules = [
    {
      api_groups = [
        "",
      ]

      resources = [
        "namespaces",
        "pods",
      ]

      verbs = [
        "get",
        "list",
        "watch",
      ]
    },
  ]
}
