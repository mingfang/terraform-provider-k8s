# terraform-provider-k8s
terraform-provider-k8s is a Terraform provider to manage Kubernetes resources.

- Uses the Kubernetes client-go library to dynamically discover available resources
- Supports multiple versions of the same resource kinds, including aplha and beta versions

## Requirements
 - Docker
 - kubeconfig file in the current directory
 
## Install
1. ```docker pull registry.rebelsoft.com/terraform```
2. ```alias tf='docker run -v `pwd`/kubeconfig:/kubeconfig -v `pwd`:/docker -w /docker --rm -it registry.rebelsoft.com/terraform terraform'```
3. ```alias tfextract='docker run -v `pwd`/kubeconfig:/kubeconfig -v `pwd`:/docker -w /docker --rm -it registry.rebelsoft.com/terraform extractor'```
4. ```alias tfgenerate='docker run -v `pwd`/kubeconfig:/kubeconfig -v `pwd`:/docker -w /docker --rm -it registry.rebelsoft.com/terraform generator'```

## Init
For new projects or after install/upgrade, run ```tf init```

## List Resource Types
Run ```tfgenerate``` to list all available resource types

## Generate
Run ```tfgenerate <resource>``` to generate a skeleton tf file for the resource. For example,

- ```tfgenerate k8s_core_v1_service``` to generate a Kubernetes Service
- ```tfgenerate k8s_apps_v1_deployment``` to generate a Kubernetes Deployment
- ```tfgenerate k8s_apps_v1_stateful_set``` to generate a Kubernetes StatefulSet

## Extract From YAML File
The ```tfextract``` will load the existing resources from YAML files and create Terraform files for them.  One file per resource in the YAML file.

Run the ```tfextract -filename <>``` command.

## Extract From Kubernetes
The ```tfextract``` will load the existing resources from Kubernetes and create Terraform files for them.  One file per resource.

Run the ```tfextract -namespace <> -kind <> -name <>``` command. Any may be left blank but at least one must be set.

Example: ```tfextract -kind service -name nginx``` will extract the Service named nginx into a file called service-nginx.tf.

If ```-kind service``` was left blank then all resources named nginx will be extracted to their coresponding files.  Likewise for ```-name nginx```; if left blank then all services will be extracted.

## Import
After extracting existing resources to tf files, you can import the state for them.

Run ```tf import k8s_core_v1_service.nginx default.service.nginx``` to import, in this case a nginx service.

## Resource Format
The resource format is ```resource "k8s_<group>_<version>_<kind>" "<name>"```.

Note the ```name``` here is the Terraform name and not the Kubernetes name.  

All Kubernetes resources requires a name in the metadata like this
```
metadata {
  name = "nginx"
}
```

The set of supported groups, versions and kinds are loaded dynamically from your Kubernetes cluster.

## Id Format
The format of the resource Ids is ```<namespace>.<kind>.<name>```.  These are all Kubernetes identifiers.

Ids are used internally by Terraform to uniquely identify resource state.

The user will only need to know them when importing state from a Kubernetes cluster.

## Example
[guestbook.tf](./examples/guestbook/guestbook.tf)

Based on the official guessbook example https://github.com/kubernetes/examples/blob/master/guestbook/all-in-one/guestbook-all-in-one.yaml

