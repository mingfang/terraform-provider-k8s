variable "name" {
  default = "jupyter"
}

variable "namespace" {
  default = "jupyter"
}

variable "ingress_ip" {
  default = "192.168.2.146"
}

variable "ingress_node_port" {
  default = "30080"
}

variable "user_pvc_name" {
  default = "jupyter-users"
}

variable "user_storage" {
  default = "1Gi"
}

resource "k8s_core_v1_namespace" "this" {
  metadata {
    labels = {
      "istio-injection" = "disabled"
    }

    name = var.namespace
  }
}

module "nfs-server" {
  source    = "git::https://github.com/mingfang/terraform-provider-k8s.git//modules/nfs-server-empty-dir"
  name      = "nfs-server"
  namespace = k8s_core_v1_namespace.this.metadata.0.name
}

resource "k8s_core_v1_persistent_volume" "jupyter-users" {

  metadata {
    name = var.name
  }

  spec {
    storage_class_name               = var.name
    persistent_volume_reclaim_policy = "Retain"
    access_modes                     = ["ReadWriteOnce"]

    capacity = {
      storage = var.user_storage
    }

    nfs {
      path   = "/"
      server = module.nfs-server.service.spec.0.cluster_ip
    }

    mount_options = module.nfs-server.mount_options
  }

  lifecycle {
    ignore_changes = [metadata]
  }
}

resource "k8s_core_v1_persistent_volume_claim" "jupyter-users" {

  metadata {
    name      = var.user_pvc_name
    namespace = var.namespace
  }

  spec {
    storage_class_name = k8s_core_v1_persistent_volume.jupyter-users.spec.0.storage_class_name
    volume_name        = k8s_core_v1_persistent_volume.jupyter-users.metadata.0.name
    access_modes       = ["ReadWriteOnce"]

    resources {
      requests = {
        storage = var.user_storage
      }
    }
  }

  lifecycle {
    ignore_changes = [metadata]
  }
}

module "config" {
  source    = "../../modules/jupyter/jupyterhub/config"
  name      = var.name
  namespace = k8s_core_v1_namespace.this.metadata.0.name

  hub_extraConfig = {
    "enterprise-gateway" = "config = '/etc/jupyter/jupyter_notebook_config.py'"
  }
  singleuser_extraEnv = {
    "KG_URL"             = "http://enterprise-gateway:8888",
    "KG_HTTP_USER"       = "jovyan",
    "KERNEL_USERNAME"    = "jovyan",
    "KG_REQUEST_TIMEOUT" = "60",
  }
  singleuser_image_name = "jupyter/minimal-notebook"
  singleuser_image_tag  = "latest"
  singleuser_profile_list = [
    {
      display_name  = "Minimal environment",
      "description" = "To avoid too much bells and whistles: Python.",
      "default"     = "true",
    },
    {
      "display_name" = "Datascience environment",
      "description"  = "If you want the additional bells and whistles: Python, R, and Julia.",
      "kubespawner_override" = {
        "image" = "jupyter/datascience-notebook:latest",
      }
    },
    {
      "display_name" = "Spark environment",
      description    = "The Jupyter Stacks spark image!",
      kubespawner_override = {
        image = "jupyter/all-spark-notebook:latest",
      }
    },
    {
      "display_name" = "elyra/nb2kg",
      description    = "elyra/nb2kg",
      kubespawner_override = {
        image = "elyra/nb2kg:dev",
      }
    },
  ]
  singleuser_storage_static_pvcName = var.user_pvc_name
}

module "proxy" {
  source    = "../../modules/jupyter/jupyterhub/proxy"
  name      = "${var.name}-proxy"
  namespace = k8s_core_v1_namespace.this.metadata.0.name

  annotations = {
    "config-version" = module.config.config_map.metadata.0.resource_version
    "secret-version" = module.config.secret.metadata.0.resource_version
  }
  secret_name      = module.config.secret.metadata.0.name
  hub_service_host = "${var.name}-hub"
  hub_service_port = 8081
}

module "hub" {
  source    = "../../modules/jupyter/jupyterhub/hub"
  name      = "${var.name}-hub"
  namespace = k8s_core_v1_namespace.this.metadata.0.name

  annotations = {
    "config-version" = module.config.config_map.metadata.0.resource_version
    "secret-version" = module.config.secret.metadata.0.resource_version
  }
  config_map                = module.config.config_map.metadata.0.name
  secret_name               = module.config.secret.metadata.0.name
  proxy_api_service_host    = "${var.name}-proxy"
  proxy_api_service_port    = 8001
  proxy_public_service_host = "${var.name}.${var.ingress_ip}.nip.io"
  proxy_public_service_port = var.ingress_node_port
}

module "ingress-rules" {
  source        = "git::https://github.com/mingfang/terraform-provider-k8s.git//modules/kubernetes/ingress-rules"
  name          = var.name
  namespace     = k8s_core_v1_namespace.this.metadata.0.name
  ingress_class = "nginx"
  rules = [
    {
      host = "${var.name}.${var.ingress_ip}.nip.io"

      http = {
        paths = [
          {
            path = "/"

            backend = {
              service_name = module.proxy.service.metadata.0.name
              service_port = module.proxy.service.spec.0.ports.0.port
            }
          },
        ]
      }
    },
  ]
}

module "preloader" {
  source = "../../archetypes/daemonset"
  parameters = {
    name      = "${var.name}-preloader"
    namespace = k8s_core_v1_namespace.this.metadata.0.name
    containers = [
      {
        command = ["sleep", "infinity"]
        image   = "jupyter/minimal-notebook"
        name    = "minimal-notebook"
      },
      {
        command = ["sleep", "infinity"]
        image   = "jupyter/datascience-notebook:latest"
        name    = "datascience-notebook"
      },
      {
        command = ["sleep", "infinity"]
        image   = "jupyter/all-spark-notebook:latest"
        name    = "all-spark-notebook"
      },
      {
        command = ["sleep", "infinity"]
        image   = "elyra/nb2kg:dev"
        name    = "nb2kg"
      },
      {
        command = ["sleep", "infinity"]
        image   = "elyra/enterprise-gateway:2.0.0rc1"
        name    = "enterprise-gateway"
      },
      {
        command = ["sleep", "infinity"]
        image   = "elyra/kernel-py:2.0.0rc1"
        name    = "kernel-py"
      },
    ]
  }
}

module "enterprise-gateway" {
  source    = "../../modules/jupyter/enterprise-gateway"
  namespace = k8s_core_v1_namespace.this.metadata.0.name
}