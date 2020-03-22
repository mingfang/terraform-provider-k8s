module github.com/mingfang/terraform-provider-k8s

go 1.12

// Forked for critical feature https://github.com/mingfang/terraform/commit/c81184ae9eb1d557596b5a3fa9db8cff2149db9c

replace github.com/hashicorp/terraform-plugin-sdk => github.com/mingfang/terraform-plugin-sdk v1.0.1-0.20200115023446-4002fbe119e8

require (
	github.com/awalterschulze/gographviz v0.0.0-20190522210029-fa59802746ab
	github.com/davecgh/go-spew v1.1.1
	github.com/gogo/protobuf v1.3.0
	github.com/gruntwork-io/terratest v0.18.5
	github.com/hashicorp/terraform-plugin-sdk v1.4.1
	github.com/kr/pty v1.1.5 // indirect
	github.com/onsi/ginkgo v1.11.0 // indirect
	istio.io/api v0.0.0-20200322030109-fefdc2c66190
	istio.io/istio v0.0.0-20200322024012-82c68cffd594
	k8s.io/apimachinery v0.17.2
	k8s.io/cli-runtime v0.17.2
	k8s.io/client-go v0.17.2
	k8s.io/kube-openapi v0.0.0-20191107075043-30be4d16710a
	k8s.io/utils v0.0.0-20191217005138-9e5e9d854fcc // indirect
)
