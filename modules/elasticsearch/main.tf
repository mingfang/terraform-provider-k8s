/**
 * Module usage:
 *
 *     module "elasticsearch" {
 *       source             = "git::https://github.com/mingfang/terraform-provider-k8s.git//modules/elasticsearch"
 *       name               = "test-elasticsearch"
 *       storage_class_name = "test-elasticsearch"
 *       storage            = "100Gi"
 *       replicas           = "${k8s_core_v1_persistent_volume.test-elasticsearch.count}"
 *     }
 *     
 *     resource "k8s_core_v1_persistent_volume" "test-elasticsearch" {
 *       count = 3
 *     
 *       metadata {
 *         name = "pvc-test-elasticsearch-${count.index}"
 *       }
 *     
 *       spec {
 *         storage_class_name               = "test-elasticsearch"
 *         persistent_volume_reclaim_policy = "Retain"
 *     
 *         access_modes = [
 *           "ReadWriteMany",
 *         ]
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
 *             name = "ceph-secret"
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
  default = "docker.elastic.co/elasticsearch/elasticsearch:6.4.2"
}

variable "node_selector" {
  type    = "map"
  default = {}
}

variable storage_class_name {}

variable storage {}

/*
statefulset specific
*/

variable volume_claim_template_name {
  default = "pvc"
}

/*
service specific variables
*/

variable "heap_size" {
  default = "4g"
}

locals {
  labels = {
    app     = "${var.name}"
    name    = "${var.name}"
    service = "${var.name}"
  }
}

/*
service
*/

resource "k8s_core_v1_service" "elasticsearch" {
  metadata {
    name      = "${var.name}"
    namespace = "${var.namespace}"
    labels    = "${local.labels}"
  }

  spec {
    cluster_ip = "None"
    selector   = "${local.labels}"

    ports = [
      {
        name = "http"
        port = 9200
      },
      {
        name = "tcp"
        port = 9300
      },
    ]
  }
}

/*
statefulset
*/

resource "k8s_apps_v1_stateful_set" "elasticsearch" {
  metadata {
    name      = "${var.name}"
    namespace = "${var.namespace}"
    labels    = "${local.labels}"
  }

  spec {
    replicas              = "${var.replicas}"
    service_name          = "${var.name}"
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
            name  = "elasticsearch"
            image = "${var.image}"

            env = [
              {
                name  = "cluster.name"
                value = "${var.name}"
              },
              {
                name = "node.name"

                value_from {
                  field_ref {
                    field_path = "metadata.name"
                  }
                }
              },
              {
                name  = "discovery.zen.ping.unicast.hosts"
                value = "${var.name}"
              },
              {
                name  = "ES_JAVA_OPTS"
                value = "-Xms${var.heap_size} -Xmx${var.heap_size}"
              },
              {
                name = "POD_NAME"

                value_from {
                  field_ref {
                    field_path = "metadata.name"
                  }
                }
              },
              {
                name  = "path.data"
                value = "/data/$(POD_NAME)"
              },
            ]

            readiness_probe {
              failure_threshold     = 3
              initial_delay_seconds = 30
              period_seconds        = 10
              success_threshold     = 1
              timeout_seconds       = 1

              http_get {
                path   = "/"
                port   = 9200
                scheme = "HTTP"
              }
            }

            resources {
              requests {
                cpu    = "250m"
                memory = "4Gi"
              }
            }

            volume_mounts {
              name       = "pvc"
              mount_path = "/data"
              sub_path   = "${var.name}"
            }
          },
        ]

        init_containers = [
          {
            name              = "fix-the-volume-permission"
            image             = "busybox"
            image_pull_policy = "IfNotPresent"

            command = [
              "sh",
              "-c",
              "chown -R 1000:1000 /data",
            ]

            security_context {
              privileged = true
            }

            volume_mounts {
              name       = "pvc"
              mount_path = "/data"
              sub_path   = "${var.name}"
            }
          },
          {
            name              = "increase-the-vm-max-map-count"
            image             = "busybox"
            image_pull_policy = "IfNotPresent"

            command = [
              "sysctl",
              "-w",
              "vm.max_map_count=262144",
            ]

            security_context {
              privileged = true
            }
          },
          {
            name              = "increase-the-ulimit"
            image             = "busybox"
            image_pull_policy = "IfNotPresent"

            command = [
              "sh",
              "-c",
              "ulimit -n 65536",
            ]

            security_context {
              privileged = true
            }
          },
        ]
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
