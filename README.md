# terraform-provider-k8s
terraform-provider-k8s is a Terraform plugin to manage Kubernetes resources.

## Requirement
 - Docker
 - kubeconfig file in the current directory
 
## Install
1. ```docker pull registry.rebelsoft.com/terraform```
2. ```alias tf='docker run -v `pwd`/kubeconfig:/kubeconfig -v `pwd`:/docker -w /docker --rm -it terraform terraform'```

## Init
For new projects or after install/upgrade, run ```tf init```

