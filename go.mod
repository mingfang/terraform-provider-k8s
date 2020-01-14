module github.com/mingfang/terraform-provider-k8s

go 1.12

// Forked for critical feature https://github.com/mingfang/terraform/commit/c81184ae9eb1d557596b5a3fa9db8cff2149db9c

replace github.com/hashicorp/terraform-plugin-sdk => github.com/mingfang/terraform-plugin-sdk v1.0.1-0.20191109223005-48c5d8417d1c

require (
	github.com/awalterschulze/gographviz v0.0.0-20190522210029-fa59802746ab
	github.com/davecgh/go-spew v1.1.1
	github.com/emicklei/go-restful v2.9.6+incompatible // indirect
	github.com/evanphx/json-patch v4.5.0+incompatible // indirect
	github.com/gogo/protobuf v1.3.0 // indirect
	github.com/googleapis/gnostic v0.3.1 // indirect
	github.com/gregjones/httpcache v0.0.0-20190611155906-901d90724c79 // indirect
	github.com/gruntwork-io/terratest v0.18.5
	github.com/hashicorp/terraform-plugin-sdk v1.3.0
	github.com/imdario/mergo v0.3.7 // indirect
	github.com/magiconair/properties v1.8.1 // indirect
	github.com/mattn/go-isatty v0.0.10 // indirect
	github.com/onsi/ginkgo v1.11.0 // indirect
	github.com/ulikunitz/xz v0.5.6 // indirect
	golang.org/x/net v0.0.0-20191014212845-da9a3fd4c582 // indirect
	golang.org/x/sys v0.0.0-20191010194322-b09406accb47 // indirect
	google.golang.org/genproto v0.0.0-20191009194640-548a555dbc03 // indirect
	google.golang.org/grpc v1.25.1 // indirect
	gopkg.in/check.v1 v1.0.0-20190902080502-41f04d3bba15 // indirect
	gopkg.in/yaml.v2 v2.2.7 // indirect
	k8s.io/apimachinery v0.17.0
	k8s.io/cli-runtime v0.17.0
	k8s.io/client-go v0.17.0
	k8s.io/kube-openapi v0.0.0-20191107075043-30be4d16710a
	k8s.io/utils v0.0.0-20191217005138-9e5e9d854fcc // indirect
)
