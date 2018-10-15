# terraform-provider-k8s
terraform-provider-k8s is a Terraform plugin to manage Kubernetes resources.

## Requirement
 - Docker
 - kubeconfig file in the current directory
 
## Install
1. ```docker pull registry.rebelsoft.com/terraform```
2. ```alias tf='docker run -v `pwd`/kubeconfig:/kubeconfig -v `pwd`:/docker -w /docker --rm -it terraform terraform'```
3. ```alias tfextractor='docker run -v `pwd`/kubeconfig:/kubeconfig -v `pwd`:/docker -w /docker --rm -it terraform extractor'```


## Init
For new projects or after install/upgrade, run ```tf init```

## Extract existing Kubernetes resources into Terraform *.tf files
Run the ```tfextractor``` command.  The ```tfextractor``` will load the existing resources from Kubernetes and create Terraform files for them.  One file per resource.

## Example
[guestbook.tf](./examples/guestbook/guestbook.tf)

Based on the official guessbook example https://github.com/kubernetes/examples/blob/master/guestbook/all-in-one/guestbook-all-in-one.yaml

