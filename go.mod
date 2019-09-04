module github.com/mingfang/terraform-provider-k8s

go 1.12

// Forked for critical feature https://github.com/mingfang/terraform/commit/c81184ae9eb1d557596b5a3fa9db8cff2149db9c

replace github.com/hashicorp/terraform => github.com/mingfang/terraform v0.12.0-alpha4.0.20190903012643-8c315fe01438

exclude (
	istio.io/api v0.0.0-20190829032130-adb6f9e24baf
	istio.io/istio v0.0.0-20190903014430-73b6b45757e9
)

require (
	github.com/Azure/go-autorest v11.1.2+incompatible // indirect
	github.com/awalterschulze/gographviz v0.0.0-20190522210029-fa59802746ab
	github.com/davecgh/go-spew v1.1.1
	github.com/gogo/protobuf v1.3.0
	github.com/gregjones/httpcache v0.0.0-20190611155906-901d90724c79 // indirect
	github.com/gruntwork-io/terratest v0.18.5
	github.com/hashicorp/terraform v0.0.0-00010101000000-000000000000
	k8s.io/apimachinery v0.0.0-20190831074630-461753078381
	k8s.io/cli-runtime v0.0.0-20190831080432-9d670f2021f4
	k8s.io/client-go v0.0.0-20190831074946-3fe2abece89e
	k8s.io/kube-openapi v0.0.0-20190816220812-743ec37842bf
	k8s.io/utils v0.0.0-20190829053155-3a4a5477acf8 // indirect
)
