resource "k8s_rbac_authorization_k8s_io_v1_cluster_role" "gitlab" {
  metadata {
    name = "${var.name}"
  }

  rules = [
    {
      api_groups = [
        "",
      ]

      resources = [
        "nodes",
        "nodes/proxy",
        "services",
        "endpoints",
        "pods",
      ]

      verbs = [
        "get",
        "list",
        "watch",
      ]
    },
    {
      api_groups = [
        "extensions",
      ]

      resources = [
        "ingresses",
      ]

      verbs = [
        "get",
        "list",
        "watch",
      ]
    },
    {
      non_resource_urls = [
        "/metrics",
      ]

      verbs = [
        "get",
      ]
    },
  ]
}
