clear
rm /usr/local/bin/terraform-provider-k8s*
go build -o /usr/local/bin/terraform-provider-k8s_v1.0.0
ln -s -f /usr/local/bin/terraform-provider-k8s_v1.0.0 /go/bin/terraform-provider-k8s_v1.0.0
terraform init
