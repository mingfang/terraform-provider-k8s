resource "k8s_apiextensions_k8s_io_v1beta1_custom_resource_definition" "clusterrbacconfigs_rbac_istio_io" {
  metadata {
    annotations = {
      "helm.sh/resource-policy" = "keep"
    }
    labels = {
      "istio"    = "rbac"
      "release"  = "istio"
      "app"      = "istio-pilot"
      "heritage" = "Tiller"
    }
    name = "clusterrbacconfigs.rbac.istio.io"
  }
  spec {
    group = "rbac.istio.io"
    names {
      categories = [
        "istio-io",
        "rbac-istio-io",
      ]
      kind     = "ClusterRbacConfig"
      plural   = "clusterrbacconfigs"
      singular = "clusterrbacconfig"
    }
    scope   = "Cluster"
    version = "v1alpha1"
  }
}