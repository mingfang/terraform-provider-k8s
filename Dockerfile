FROM golang as base
RUN apt-get update
RUN apt-get install -y vim unzip zip

RUN wget -O /usr/local/bin/terraform-docs https://github.com/segmentio/terraform-docs/releases/download/v0.6.0/terraform-docs-v0.6.0-linux-amd64 && \
    chmod +x /usr/local/bin/terraform-docs

#Docker client only
RUN wget -O - https://get.docker.com/builds/Linux/x86_64/docker-latest.tgz | tar zx -C /usr/local/bin --strip-components=1 docker/docker

#Helm
RUN wget -O - https://get.helm.sh/helm-v3.0.0-beta.3-linux-amd64.tar.gz | tar zx -C /usr/local/bin --strip-components=1 linux-amd64/helm

# goreleaser
RUN wget -O - https://github.com/goreleaser/goreleaser/releases/download/v0.118.2/goreleaser_Linux_x86_64.tar.gz|tar zx
RUN chmod +x goreleaser && \
    mv goreleaser /usr/local/bin


FROM base as dev
ENV GO111MODULE=on

#Terraform master branch
#ENV COMMIT v0.12.9
#RUN git clone https://github.com/hashicorp/terraform.git $GOPATH/src/github.com/hashicorp/terraform
#RUN cd "$GOPATH/src/github.com/hashicorp/terraform" && \
#    git checkout $COMMIT && \
#    make tools && \
#    XC_OS=linux XC_ARCH=amd64 make bin
#RUN mv /go/bin/terraform /usr/local/bin/terraform

RUN wget https://releases.hashicorp.com/terraform/0.12.15/terraform_0.12.15_linux_amd64.zip && \
    unzip *.zip && \
    mv terraform /usr/local/bin && \
    rm *.zip

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
COPY --from=build /usr/local/bin/terraform-provider-k8s /usr/local/bin/
COPY --from=build /usr/local/bin/extractor /usr/local/bin/
COPY --from=build /usr/local/bin/generator /usr/local/bin/
