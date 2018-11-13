/**
 * Module usage:
 *
 *     module "zookeeper" {
 *       source             = "git::https://github.com/mingfang/terraform-provider-k8s.git//modules/zookeeper"
 *       name               = "test-zookeeper"
 *       storage_class_name = "test-zookeeper"
 *       storage            = "100Gi"
 *       replicas           = "${k8s_core_v1_persistent_volume.test-zookeeper.count}"
 *     }
 *
 *     resource "k8s_core_v1_persistent_volume" "test-zookeeper" {
 *       count = 3
 *
 *       metadata {
 *         name = "pvc-test-zookeeper-${count.index}"
 *       }
 *
 *       spec {
 *         storage_class_name               = "test-zookeeper"
 *         persistent_volume_reclaim_policy = "Retain"
 *         access_modes                     = ["ReadWriteOnce"]
 *
 *         capacity {
 *           storage = "100Gi"
 *         }
 *
 *         cephfs {
 *           user = "admin"
 *
 *           monitors = [
 *             "192.168.2.89",
 *             "192.168.2.39",
 *           ]
 *
 *           secret_ref {
 *             name      = "ceph-secret"
 *             namespace = "default"
 *           }
 *         }
 *       }
 *     }
 */

/*
common variables
*/

variable "name" {}

variable "namespace" {
  default = "default"
}

variable "replicas" {
  default = 1
}

variable image {
  default = "zookeeper"
}

variable "node_selector" {
  type    = "map"
  default = {}
}

/*
statefulset specific
*/

variable storage_class_name {}

variable storage {}

variable volume_claim_template_name {
  default = "pvc"
}

locals {
  labels = {
    app     = "${var.name}"
    name    = "${var.name}"
    service = "${var.name}"
  }
}

data "template_file" "zoo-servers" {
  count    = "${var.replicas}"
  template = "server.${count.index}=${var.name}-${count.index}.${var.name}.${var.namespace}.svc.cluster.local:2888:3888"
}

/*
service
*/

resource "k8s_core_v1_service" "this" {
  metadata {
    name      = "${var.name}"
    namespace = "${var.namespace}"
    labels    = "${local.labels}"
  }

  spec {
    selector = "${local.labels}"

    ports = [
      {
        name = "client"
        port = 2181
      },
      {
        name = "server"
        port = 2888
      },
      {
        name = "leader-election"
        port = 3888
      },
    ]
  }
}

/*
statefulset
*/

resource "k8s_apps_v1_stateful_set" "this" {
  metadata {
    name      = "${var.name}"
    namespace = "${var.namespace}"
    labels    = "${local.labels}"
  }

  spec {
    replicas              = "${var.replicas}"
    service_name          = "${k8s_core_v1_service.this.metadata.0.name}"
    pod_management_policy = "OrderedReady"

    selector {
      match_labels = "${local.labels}"
    }

    update_strategy {
      type = "RollingUpdate"

      rolling_update {
        partition = 0
      }
    }

    template {
      metadata {
        labels = "${local.labels}"
      }

      spec {
        node_selector = "${var.node_selector}"

        affinity {
          pod_anti_affinity {
            required_during_scheduling_ignored_during_execution {
              label_selector {
                match_expressions {
                  key      = "app"
                  operator = "In"
                  values   = ["${var.name}"]
                }
              }

              topology_key = "kubernetes.io/hostname"
            }
          }
        }

        containers = [
          {
            name  = "zookeeper"
            image = "${var.image}"

            env = [
              {
                name = "POD_NAME"

                value_from {
                  field_ref {
                    field_path = "metadata.name"
                  }
                }
              },
              {
                name  = "ZOO_DATA_DIR"
                value = "/data/$(POD_NAME)"
              },
              {
                name  = "ZOO_SERVERS"
                value = "${join(" ", data.template_file.zoo-servers.*.rendered)}"
              },
            ]

            liveness_probe {
              initial_delay_seconds = 1
              timeout_seconds       = 3

              exec {
                command = [
                  "/bin/bash",
                  "-cx",
                  "echo 'ruok' | nc localhost 2181 | grep imok",
                ]
              }
            }

            resources {
              requests {
                cpu    = "500m"
                memory = "1Gi"
              }
            }

            volume_mounts {
              name       = "${var.volume_claim_template_name}"
              mount_path = "/data"
              sub_path   = "${var.name}"
            }
          },
        ]

        init_containers = [
          {
            name  = "set-myid"
            image = "${var.image}"

            env = [
              {
                name = "POD_NAME"

                value_from {
                  field_ref {
                    field_path = "metadata.name"
                  }
                }
              },
              {
                name  = "ZOO_DATA_DIR"
                value = "/data/$(POD_NAME)"
              },
            ]

            command = [
              "bash",
              "-cx",
              "mkdir -p $ZOO_DATA_DIR; echo \"$${HOSTNAME//[^0-9]/}\" > $ZOO_DATA_DIR/myid",
            ]

            resources {}

            volume_mounts {
              name       = "${var.volume_claim_template_name}"
              mount_path = "/data"
              sub_path   = "${var.name}"
            }
          },
        ]

        security_context {}
      }
    }

    volume_claim_templates {
      metadata {
        name = "${var.volume_claim_template_name}"
      }

      spec {
        storage_class_name = "${var.storage_class_name}"
        access_modes       = ["ReadWriteOnce"]

        resources {
          requests {
            storage = "${var.storage}"
          }
        }
      }
    }
  }
}

resource "k8s_policy_v1beta1_pod_disruption_budget" "this" {
  metadata {
    name = "${var.name}"
  }

  spec {
    max_unavailable = 1

    selector {
      match_labels = "${local.labels}"
    }
  }
}

output "name" {
  value = "${k8s_core_v1_service.this.metadata.0.name}"
}
