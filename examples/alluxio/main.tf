variable "name" {
  default = "alluxio"
}

variable "namespace" {
  default = "alluxio"
}

variable "ingress-ip" {
  default = "192.168.2.146"
}

variable "ingress-node-port" {
  default = "30080"
}

resource "k8s_core_v1_namespace" "this" {
  metadata {
    labels = {
      "istio-injection" = "disabled"
    }

    name = var.namespace
  }
}

module "master" {
  source    = "../../modules/alluxio/master"
  name      = "${var.name}-master"
  namespace = k8s_core_v1_namespace.this.metadata.0.name
  overrides = {
    image_pull_policy = "Always"
  }
  env = [
    {
      name  = "ALLUXIO_MASTER_MOUNT_TABLE_ROOT_UFS"
      value = "s3a://alluxio"
    },
    {
      name  = "ALLUXIO_UNDERFS_S3_ENDPOINT"
      value = "http://minio.minio.svc.cluster.local:9000"
    },
    {
      name  = "ALLUXIO_UNDERFS_S3_DISABLE_DNS_BUCKETS"
      value = "true"
    },
    {
      name  = "ALLUXIO_UNDERFS_S3A_INHERIT_ACL"
      value = "false"
    },
    {
      name  = "AWS_ACCESSKEYID"
      value = "IUWU60H2527LP7DOYJVP"
    },
    {
      name  = "AWS_SECRETKEY"
      value = "bbdGponYV5p9P99EsasLSu4K3SjYBEcBLtyz7wbm"
    },
    {
      name  = "ALLUXIO_JAVA_OPTS"
      value = "-Dalluxio.master.audit.logging.enabled=true"
    },
  ]
}

module "worker" {
  source    = "../../modules/alluxio/worker"
  name      = "${var.name}-worker"
  namespace = k8s_core_v1_namespace.this.metadata.0.name
  overrides = {
    image_pull_policy = "Always"
  }
  env = [
    {
      name  = "ALLUXIO_UNDERFS_S3_ENDPOINT"
      value = "http://minio.minio.svc.cluster.local:9000"
    },
    {
      name  = "ALLUXIO_UNDERFS_S3_DISABLE_DNS_BUCKETS"
      value = "true"
    },
    {
      name  = "ALLUXIO_UNDERFS_S3A_INHERIT_ACL"
      value = "false"
    },
    {
      name  = "AWS_ACCESSKEYID"
      value = "IUWU60H2527LP7DOYJVP"
    },
    {
      name  = "AWS_SECRETKEY"
      value = "bbdGponYV5p9P99EsasLSu4K3SjYBEcBLtyz7wbm"
    },
  ]
  alluxio_master_hostname = module.master.service.metadata.0.name
  alluxio_master_port     = module.master.service.spec.0.ports.0.port
}

/*
module "fuse" {
  source = "../../modules/alluxio/fuse"
  name = "${var.name}-fuse"
  namespace = k8s_core_v1_namespace.this.metadata.0.name
  alluxio_master_hostname = module.master.service.metadata.0.name
  alluxio_master_port = module.master.service.spec.0.ports.0.port
  overrides = {
    image_pull_policy = "Always"
  }
}
*/

module "csi" {
  source    = "../../modules/alluxio/csi"
  name = var.name
  namespace = k8s_core_v1_namespace.this.metadata.0.name
}

resource "k8s_storage_k8s_io_v1_storage_class" "this" {
  metadata {
    name      = var.name
  }

  _provisioner = "alluxio"
  parameters = {
    "alluxio.master.hostname" = "${module.master.service.metadata.0.name}.${module.master.service.metadata.0.namespace}",
    "alluxio.master.port"     = module.master.service.spec.0.ports.0.port
  }
}



module "ingress-rules" {
  source        = "git::https://github.com/mingfang/terraform-provider-k8s.git//modules/kubernetes/ingress-rules"
  name          = var.name
  namespace     = k8s_core_v1_namespace.this.metadata.0.name
  ingress_class = "nginx"
  rules = [
    {
      host = "${var.name}.rebelsoft.com"

      http = {
        paths = [
          {
            path = "/"

            backend = {
              service_name = module.master.service.metadata.0.name
              service_port = module.master.service.spec.0.ports.1.port
            }
          },
        ]
      }
    },
  ]
}
