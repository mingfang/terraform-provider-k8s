clear
rm -r ~/.terraform.d
DIR=~/.terraform.d/plugins/mingfang/k8s/0.0.0/linux_amd64
mkdir -p $DIR

go build -o $DIR/terraform-provider-k8s
terraform init
