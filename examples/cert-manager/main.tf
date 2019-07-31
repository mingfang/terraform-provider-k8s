variable "name" {}

resource "k8s_core_v1_namespace" "this" {
  metadata {
    labels = {
      "certmanager.k8s.io/disable-validation" = "true"
    }
    name = var.name
  }
}

module "cert-manager" {
  source    = "../../modules/cert-manager"
  namespace = k8s_core_v1_namespace.this.metadata[0].name
}

resource "k8s_certmanager_k8s_io_v1alpha1_cluster_issuer" "this" {
  metadata {
    name      = "test-selfsigned"
  }

  spec {
    self_signed = { "" = "" } //hack since TF does not allow empty values
  }
}

resource "k8s_certmanager_k8s_io_v1alpha1_certificate" "this" {
  metadata {
    name      = "selfsigned-cert"
    namespace = k8s_core_v1_namespace.this.metadata[0].name
  }

  spec {
    common_name = "example.com"
    secret_name = "selfsigned-cert-tls"
    issuer_ref {
      name = k8s_certmanager_k8s_io_v1alpha1_cluster_issuer.this.metadata[0].name
      kind = "ClusterIssuer"
    }
  }

}

