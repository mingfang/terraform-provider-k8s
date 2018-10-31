Module usage:

    module "elasticsearch" {
      source             = "git::https://github.com/mingfang/terraform-provider-k8s.git//modules/elasticsearch"
      name               = "test-elasticsearch"
      storage_class_name = "test-elasticsearch"
      storage            = "100Gi"
      replicas           = "${k8s_core_v1_persistent_volume.test-elasticsearch.count}"
    }

    resource "k8s_core_v1_persistent_volume" "test-elasticsearch" {
      count = 3

      metadata {
        name = "pvc-test-elasticsearch-${count.index}"
      }

      spec {
        storage_class_name               = "test-elasticsearch"
        persistent_volume_reclaim_policy = "Retain"

        access_modes = [
          "ReadWriteMany",
        ]

        capacity {
          storage = "100Gi"
        }

        cephfs {
          user = "admin"

          monitors = [
            "192.168.2.89",
            "192.168.2.39",
          ]

          secret_ref {
            name = "ceph-secret"
            namespace = "default"
          }
        }
      }
    }

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| name | - | string | `elasticsearch` | no |
| namespace | - | string | `default` | no |
| replicas | - | string | `2` | no |
| image | - | string | `docker.elastic.co/elasticsearch/elasticsearch:6.4.2` | no |
| heap\_size | - | string | `4g` | no |
| node\_selector | - | map | `<map>` | no |
| storage\_class\_name | - | string | - | yes |
| storage | - | string | - | yes |
| volume\_claim\_template\_name | - | string | `pvc` | no |

