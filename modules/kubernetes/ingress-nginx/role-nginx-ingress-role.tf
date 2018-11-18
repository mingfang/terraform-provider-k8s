resource "k8s_rbac_authorization_k8s_io_v1_role" "nginx-ingress-role" {
  metadata {
    labels    = "${local.labels}"
    name      = "${var.name}"
    namespace = "${k8s_core_v1_namespace.ingress-nginx.metadata.0.name}"
  }

  rules = [
    {
      api_groups = [
        "",
      ]

      resources = [
        "configmaps",
        "pods",
        "secrets",
        "namespaces",
      ]

      verbs = [
        "get",
      ]
    },
    {
      api_groups = [
        "",
      ]

      resource_names = [
        "ingress-controller-leader-nginx",
      ]

      resources = [
        "configmaps",
      ]

      verbs = [
        "get",
        "update",
      ]
    },
    {
      api_groups = [
        "",
      ]

      resources = [
        "configmaps",
      ]

      verbs = [
        "create",
      ]
    },
    {
      api_groups = [
        "",
      ]

      resources = [
        "endpoints",
      ]

      verbs = [
        "get",
      ]
    },
  ]
}
