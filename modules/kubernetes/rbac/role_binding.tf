//GENERATE//k8s_rbac_authorization_k8s_io_v1_role_binding//count = var.role_rules == null ? 0 : 1//ignore_changes = [metadata]
resource "k8s_rbac_authorization_k8s_io_v1_role_binding" "this" {
  count = var.role_rules == null ? 0 : 1

  metadata {
    annotations = lookup(local.k8s_rbac_authorization_k8s_io_v1_role_binding_parameters, "annotations", null)
    labels      = lookup(local.k8s_rbac_authorization_k8s_io_v1_role_binding_parameters, "labels", null)

    dynamic "managed_fields" {
      for_each = lookup(local.k8s_rbac_authorization_k8s_io_v1_role_binding_parameters, "managed_fields", [])
      content {
        api_version = lookup(managed_fields.value, "api_version", null)
        fields      = lookup(managed_fields.value, "fields", null)
        manager     = lookup(managed_fields.value, "manager", null)
        operation   = lookup(managed_fields.value, "operation", null)
        time        = lookup(managed_fields.value, "time", null)
      }
    }
    name      = lookup(local.k8s_rbac_authorization_k8s_io_v1_role_binding_parameters, "name", null)
    namespace = lookup(local.k8s_rbac_authorization_k8s_io_v1_role_binding_parameters, "namespace", null)
  }

  dynamic "role_ref" {
    for_each = lookup(local.k8s_rbac_authorization_k8s_io_v1_role_binding_parameters, "role_ref", null) == null ? [] : [local.k8s_rbac_authorization_k8s_io_v1_role_binding_parameters.role_ref]
    content {
      api_group = role_ref.value.api_group
      kind      = role_ref.value.kind
      name      = role_ref.value.name
    }
  }

  dynamic "subjects" {
    for_each = lookup(local.k8s_rbac_authorization_k8s_io_v1_role_binding_parameters, "subjects", [])
    content {
      api_group = lookup(subjects.value, "api_group", null)
      kind      = subjects.value.kind
      name      = subjects.value.name
      namespace = lookup(subjects.value, "namespace", null)
    }
  }

  lifecycle {
    ignore_changes = [metadata]
  }
}
