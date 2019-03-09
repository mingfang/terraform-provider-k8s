//GENERATE//k8s_rbac_authorization_k8s_io_v1_role//count = var.role_rules == null ? 0 : 1//ignore_changes = [metadata]
resource "k8s_rbac_authorization_k8s_io_v1_role" "this" {
  count = var.role_rules == null ? 0 : 1

  metadata {
    annotations = lookup(local.k8s_rbac_authorization_k8s_io_v1_role_parameters, "annotations", null)
    labels      = lookup(local.k8s_rbac_authorization_k8s_io_v1_role_parameters, "labels", null)
    name        = lookup(local.k8s_rbac_authorization_k8s_io_v1_role_parameters, "name", null)
    namespace   = lookup(local.k8s_rbac_authorization_k8s_io_v1_role_parameters, "namespace", null)
  }

  dynamic "rules" {
    for_each = lookup(local.k8s_rbac_authorization_k8s_io_v1_role_parameters, "rules", [])
    content {
      api_groups        = contains(keys(rules.value), "api_groups") ? rules.value.api_groups : []
      non_resource_urls = contains(keys(rules.value), "non_resource_urls") ? rules.value.non_resource_urls : []
      resource_names    = contains(keys(rules.value), "resource_names") ? rules.value.resource_names : []
      resources         = contains(keys(rules.value), "resources") ? rules.value.resources : []
      verbs             = rules.value.verbs
    }
  }

  lifecycle {
    ignore_changes = [metadata]
  }
}
