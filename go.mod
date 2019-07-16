module github.com/mingfang/terraform-provider-k8s

go 1.12

// Replace client-go dependencies until client-go@v12.0.0 is out as per https://github.com/kubernetes/client-go/blob/master/INSTALL.md#go-modules

replace k8s.io/apimachinery => k8s.io/apimachinery v0.0.0-20190404173353-6a84e37a896d

replace k8s.io/api => k8s.io/api v0.0.0-20190409021203-6e4e0e4f393b

replace k8s.io/cli-runtime => k8s.io/cli-runtime v0.0.0-20190409023024-d644b00f3b79

// Forked for critical feature https://github.com/mingfang/terraform/commit/c81184ae9eb1d557596b5a3fa9db8cff2149db9c

replace github.com/hashicorp/terraform => github.com/mingfang/terraform v0.12.0-alpha4.0.20190716124805-56125c18ce4c

require (
	github.com/awalterschulze/gographviz v0.0.0-20190522210029-fa59802746ab
	github.com/davecgh/go-spew v1.1.1
	github.com/evanphx/json-patch v4.5.0+incompatible // indirect
	github.com/gruntwork-io/terratest v0.17.0
	github.com/hashicorp/terraform v0.12.4
	github.com/imdario/mergo v0.3.7 // indirect
	github.com/peterbourgon/diskv v2.0.1+incompatible // indirect
	github.com/spf13/cobra v0.0.5 // indirect
	k8s.io/api v0.0.0-00010101000000-000000000000 // indirect
	k8s.io/apimachinery v0.0.0-00010101000000-000000000000
	k8s.io/cli-runtime v0.0.0-00010101000000-000000000000
	k8s.io/client-go v11.0.1-0.20190409021438-1a26190bd76a+incompatible
	k8s.io/kube-openapi v0.0.0-20190603182131-db7b694dc208
	k8s.io/utils v0.0.0-20190607212802-c55fbcfc754a // indirect
	sigs.k8s.io/kustomize v2.0.3+incompatible // indirect
	sigs.k8s.io/yaml v1.1.0 // indirect
)
