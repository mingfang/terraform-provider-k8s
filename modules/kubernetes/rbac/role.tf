//GENERATE DYNAMIC//k8s_rbac_authorization_k8s_io_v1_role//count = var.role_rules == null ? 0 : 1//ignore_changes = [metadata]
resource "k8s_rbac_authorization_k8s_io_v1_role" "this" {
  count = var.role_rules == null ? 0 : 1

  metadata {
    annotations = lookup(local.k8s_rbac_authorization_k8s_io_v1_role_parameters, "annotations", null)
    labels      = lookup(local.k8s_rbac_authorization_k8s_io_v1_role_parameters, "labels", null)

    dynamic "managed_fields" {
      for_each = lookup(local.k8s_rbac_authorization_k8s_io_v1_role_parameters, "managed_fields", [])
      content {
        api_version = lookup(managed_fields.value, "api_version", null)
        fields      = lookup(managed_fields.value, "fields", null)
        manager     = lookup(managed_fields.value, "manager", null)
        operation   = lookup(managed_fields.value, "operation", null)
        time        = lookup(managed_fields.value, "time", null)
      }
    }
    name      = lookup(local.k8s_rbac_authorization_k8s_io_v1_role_parameters, "name", null)
    namespace = lookup(local.k8s_rbac_authorization_k8s_io_v1_role_parameters, "namespace", null)
  }

  dynamic "rules" {
    for_each = lookup(local.k8s_rbac_authorization_k8s_io_v1_role_parameters, "rules", [])
    content {
      api_groups        = contains(keys(rules.value), "api_groups") ? tolist(rules.value.api_groups) : null
      non_resource_urls = contains(keys(rules.value), "non_resource_urls") ? tolist(rules.value.non_resource_urls) : null
      resource_names    = contains(keys(rules.value), "resource_names") ? tolist(rules.value.resource_names) : null
      resources         = contains(keys(rules.value), "resources") ? tolist(rules.value.resources) : null
      verbs             = rules.value.verbs
    }
  }

  lifecycle {
    ignore_changes = [metadata]
  }
}
