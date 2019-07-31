#!/usr/bin/env bash

# Must apply the CRDs before extracting the other cert-manager resources

alias tfextract='go run cmd/extractor/*go'

export DIR=modules/cert-manager
mkdir -p ${DIR}/crd

tfextract -dir ${DIR} -url https://raw.githubusercontent.com/jetstack/cert-manager/master/deploy/manifests/00-crds.yaml

terraform fmt ${DIR}