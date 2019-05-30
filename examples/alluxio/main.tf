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
  extra_alluxio_java_opts = join(" ", [
    "-Dalluxio.master.mount.table.root.ufs=s3a://alluxio",
    "-Dalluxio.master.mount.table.root.readonly=true",
    "-Dalluxio.master.audit.logging.enabled=true",
    "-Dalluxio.underfs.s3.endpoint=http://minio.minio.svc.cluster.local:9000",
    "-Dalluxio.underfs.s3.disable.dns.buckets=true",
    "-Dalluxio.underfs.s3a.inherit_acl=false",
    "-Daws.accessKeyId=IUWU60H2527LP7DOYJVP",
    "-Daws.secretKey=bbdGponYV5p9P99EsasLSu4K3SjYBEcBLtyz7wbm",
  ])
}

module "worker" {
  source    = "../../modules/alluxio/worker"
  name      = "${var.name}-worker"
  namespace = k8s_core_v1_namespace.this.metadata.0.name
  overrides = {
    image_pull_policy = "Always"
    update_strategy = {
      rolling_update = {
        max_unavailable = "100%"
      }
      type = "RollingUpdate"
    }
  }
  alluxio_master_hostname = module.master.service.metadata.0.name
  alluxio_master_port     = module.master.service.spec.0.ports.0.port
  extra_alluxio_java_opts = join(" ", [
    "-Dalluxio.underfs.s3.endpoint=http://minio.minio.svc.cluster.local:9000",
    "-Dalluxio.underfs.s3.disable.dns.buckets=true",
    "-Dalluxio.underfs.s3a.inherit_acl=false",
    "-Daws.accessKeyId=IUWU60H2527LP7DOYJVP",
    "-Daws.secretKey=bbdGponYV5p9P99EsasLSu4K3SjYBEcBLtyz7wbm",
  ])
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
  name      = var.name
  namespace = k8s_core_v1_namespace.this.metadata.0.name
}

module "storage-class" {
  source          = "../../modules/alluxio/csi/storage-class"
  name            = var.name
  _provisioner    = module.csi._provisioner
  master_hostname = "${module.master.service.metadata.0.name}.${module.master.service.metadata.0.namespace}"
  master_port     = module.master.service.spec.0.ports.0.port
  domain_socket   = "/opt/domain"
  java_options    = "-Xms64M -Dalluxio.security.stale.channel.purge.interval=365d"
  mount_options   = ["allow_other"]
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
