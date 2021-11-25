# terraform-provider-k8s
terraform-provider-k8s is a Terraform provider to manage Kubernetes resources.

## Features
- Supports all Kubernetes [resources](./site), including alpha and beta versions
- Supports resources based on Custom Resource Definition(CRD).
- Supports the latest version of Kubernetes
- Auto extract from live Kubernetes cluster and import as Terraform state
- Convert Kubernetes manifests to Terraform files

## Modules Catalog
A catalog of reusable modules is at [terraform-k8s-modules](https://github.com/mingfang/terraform-k8s-modules)

## Requirements
- Terraform 0.12 and 0.13
- Kubernetes v1.14+ (Recommended for best CRD support)

## Upgrading to Terraform 0.13
- Terraform 0.13 can automatically install this plugin.  Make sure your Terraform configuration block has the plugin information like this.
```
terraform {
  required_providers {
    k8s = {
      source  = "mingfang/k8s"
    }
  }
}
``` 

- If you have existing Terraform state created before Terraform 0.13 then you may have to upgrade the state using this command.
```
terraform state replace-provider 'registry.terraform.io/-/k8s' 'mingfang/k8s'
```

## Installation
Download the binary from the [releases](https://github.com/mingfang/terraform-provider-k8s/releases).

Follow official plugin installations instructions here https://www.terraform.io/docs/configuration/providers.html#third-party-plugins.
 
## Run Using Docker (optional)
```sh
docker pull registry.rebelsoft.com/terraform-provider-k8s
alias terraform='docker run -v `pwd`/kubeconfig:/kubeconfig -e KUBECONFIG=/kubeconfig -v `pwd`:/docker -w /docker --rm -it registry.rebelsoft.com/terraform-provider-k8s terraform'
alias tfextract='docker run -v `pwd`/kubeconfig:/kubeconfig -e KUBECONFIG=/kubeconfig -v `pwd`:/docker -w /docker --rm -it registry.rebelsoft.com/terraform-provider-k8s extractor'
alias tfgenerate='docker run -v `pwd`/kubeconfig:/kubeconfig -e KUBECONFIG=/kubeconfig -v `pwd`:/docker -w /docker --rm -it registry.rebelsoft.com/terraform-provider-k8s generator'
```

## Init
For new projects or after install/upgrade, run ```terraform init```

## Import
After extracting existing resources to terraform files, you can import the state for them.

Run ```terraform import k8s_core_v1_service.nginx default.service.nginx``` to import, in this case a nginx service.

## Resource Format
The resource format is ```resource "k8s_<group>_<version>_<kind>" "<name>"```.

Note the ```name``` here is the Terraform name and not the Kubernetes name.  

All Kubernetes resources requires a name in the metadata like this
```hcl
metadata {
  name = "nginx"
}
```

The set of supported groups, versions and kinds are loaded dynamically from your Kubernetes cluster.

## Data Source Format
The data source format is ```data "k8s_<group>_<version>_<kind>" "<name>"```.

The set of supported groups, versions and kinds are loaded dynamically from your Kubernetes cluster.

For example, this gets the cluster_ip of the httpbin service.

```hcl
data "k8s_core_v1_service" "httpbin" {
  metadata {
    name = "httpbin"
  }
}
output "httpbin_cluster_ip" {
  value = "${data.k8s_core_v1_service.httpbin.spec.0.cluster_ip}"
}
```

## Id Format
The format of the resource Ids is ```<namespace>.<kind>.<name>```.  These are all Kubernetes identifiers.

If the Kind of the resource is not namespaced, such as ```Namespace``` resource, then the Id format is ```.<kind>.<name>```.

Ids are used internally by Terraform to uniquely identify resource state.  The user will only need to know them when importing state from a Kubernetes cluster.

# Utilities

## List Resource Types
Run ```tfgenerate``` to list all available resource and data source types

## Generate
Run ```tfgenerate <resource>``` to generate a skeleton terraform file for the resource. For example,

- ```tfgenerate k8s_core_v1_service``` to generate a Kubernetes Service
- ```tfgenerate k8s_apps_v1_deployment``` to generate a Kubernetes Deployment
- ```tfgenerate k8s_apps_v1_stateful_set``` to generate a Kubernetes StatefulSet

## Extract From YAML File
The ```tfextract``` will load the existing resources from YAML files and create Terraform files for them.  One file per resource in the YAML file.

For local file, run the ```tfextract -filename <> -dir <target>``` command.

For remote file, run the ```tfextract -url <> -dir <target>``` command.

## Extract From Kubernetes
The ```tfextract``` will load the existing resources from Kubernetes and create Terraform files for them.  One file per resource.

Run the ```tfextract -namespace <> -kind <> -name <> -import -dir <target>``` command. Any may be left blank but at least one must be set.

Example: ```tfextract -kind service -name nginx -dir <target>``` will extract the Service named nginx into a file called service-nginx.tf.

For this example, if ```-kind service``` was left blank then all resources named nginx will be extracted to their coresponding files.  Likewise for ```-name nginx```; if left blank then all services will be extracted.

The ```-import``` flag will automatically import the extracted resources as Terraform state.

