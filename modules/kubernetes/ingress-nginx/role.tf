resource "k8s_rbac_authorization_k8s_io_v1_role" "this" {
  metadata {
    labels    = "${local.labels}"
    name      = "${var.name}"
    namespace = "${var.namespace}"
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
        "${k8s_core_v1_config_map.this.metadata.0.name}-${var.ingress_class}",
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
