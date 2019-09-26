module github.com/mingfang/terraform-provider-k8s

go 1.12

// Forked for critical feature https://github.com/mingfang/terraform/commit/c81184ae9eb1d557596b5a3fa9db8cff2149db9c

replace github.com/hashicorp/terraform-plugin-sdk => github.com/mingfang/terraform-plugin-sdk v1.0.1-0.20190926042331-ebeb63124268

exclude (
	github.com/aws/aws-sdk-go v1.22.0 // indirect
	istio.io/api v0.0.0-20190925180116-1b594bcab992
	istio.io/istio v0.0.0-20190926022541-33c1fa077bdc
	k8s.io/client-go v11.0.0+incompatible
)

require (
	github.com/apparentlymart/go-dump v0.0.0-20190214190832-042adf3cf4a0 // indirect
	github.com/awalterschulze/gographviz v0.0.0-20190522210029-fa59802746ab
	github.com/davecgh/go-spew v1.1.1
	github.com/gogo/protobuf v1.3.0
	github.com/google/go-github v17.0.0+incompatible // indirect
	github.com/google/go-querystring v1.0.0 // indirect
	github.com/gregjones/httpcache v0.0.0-20190611155906-901d90724c79 // indirect
	github.com/gruntwork-io/terratest v0.18.5
	github.com/hashicorp/go-rootcerts v1.0.0 // indirect
	github.com/hashicorp/terraform-plugin-sdk v1.0.0
	github.com/imdario/mergo v0.3.7 // indirect
	github.com/mattn/go-colorable v0.1.1 // indirect
	github.com/vmihailenco/msgpack v4.0.1+incompatible // indirect
	k8s.io/apimachinery v0.0.0-20190831074630-461753078381
	k8s.io/cli-runtime v0.0.0-20190831080432-9d670f2021f4
	k8s.io/client-go v0.0.0-20190831074946-3fe2abece89e
	k8s.io/kube-openapi v0.0.0-20190816220812-743ec37842bf
	k8s.io/utils v0.0.0-20190829053155-3a4a5477acf8 // indirect
)
