FROM golang as base
RUN apt-get update
RUN apt-get install -y vim unzip zip

#RUN wget https://releases.hashicorp.com/terraform/0.11.11/terraform_0.11.11_linux_amd64.zip && \
#RUN wget https://releases.hashicorp.com/terraform/0.12.0-alpha4/terraform_0.12.0-alpha4_terraform_0.12.0-alpha4_linux_amd64.zip && \
#    unzip terraform*.zip && \
#    rm terraform*.zip && \
#    mv terraform /usr/local/bin

RUN wget https://releases.hashicorp.com/packer/1.3.5/packer_1.3.5_linux_amd64.zip && \
    unzip packer*.zip && \
    rm packer*.zip && \
    mv packer /usr/local/bin

RUN wget -O /usr/local/bin/terraform-docs https://github.com/segmentio/terraform-docs/releases/download/v0.6.0/terraform-docs-v0.6.0-linux-amd64 && \
    chmod +x /usr/local/bin/terraform-docs

# Glide
RUN curl https://glide.sh/get | sh

#Docker client only
RUN wget -O - https://get.docker.com/builds/Linux/x86_64/docker-latest.tgz | tar zx -C /usr/local/bin --strip-components=1 docker/docker

#Helm
RUN wget -O - https://storage.googleapis.com/kubernetes-helm/helm-v2.13.1-linux-amd64.tar.gz | tar zx -C /usr/local/bin --strip-components=1 linux-amd64/helm

FROM base as dev
ENV GO111MODULE=on

#Terraform master branch
ENV COMMIT v0.12.4
RUN git clone https://github.com/hashicorp/terraform.git $GOPATH/src/github.com/hashicorp/terraform
RUN cd "$GOPATH/src/github.com/hashicorp/terraform" && \
    git checkout $COMMIT && \
    make tools && \
    XC_OS=linux XC_ARCH=amd64 make bin
RUN mv /go/bin/terraform /usr/local/bin/terraform

FROM dev as build

# Providers
RUN mkdir -p $GOPATH/src/github.com/mingfang

# terraform-provider-k8s
COPY . $GOPATH/src/github.com/mingfang/terraform-provider-k8s
RUN cd $GOPATH/src/github.com/mingfang/terraform-provider-k8s && \
    CGO_ENABLED=0 go build -o /usr/local/bin/terraform-provider-k8s

# extractor
RUN cd $GOPATH/src/github.com/mingfang/terraform-provider-k8s/cmd/extractor && \
    CGO_ENABLED=0 go build -o /usr/local/bin/extractor

# generator
RUN cd $GOPATH/src/github.com/mingfang/terraform-provider-k8s/cmd/generator && \
    CGO_ENABLED=0 go build -o /usr/local/bin/generator

FROM alpine as final
RUN apk add --no-cache ca-certificates
RUN apk add --no-cache git

COPY --from=build /usr/local/bin/terraform /usr/local/bin/
COPY --from=build /usr/local/bin/packer /usr/local/bin/
COPY --from=build /usr/local/bin/terraform-provider-k8s /usr/local/bin/
COPY --from=build /usr/local/bin/extractor /usr/local/bin/
COPY --from=build /usr/local/bin/generator /usr/local/bin/
