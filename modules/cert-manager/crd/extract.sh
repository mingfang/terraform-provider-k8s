#!/usr/bin/env bash

alias tfextract='go run cmd/extractor/*go'

export DIR=modules/cert-manager
mkdir -p ${DIR}/tmp
mkdir -p ${DIR}/crd

rm ${DIR}/tmp/*
tfextract -dir ${DIR}/tmp -url https://github.com/jetstack/cert-manager/releases/download/v0.9.0/cert-manager.yaml

# CRDs
mv ${DIR}/tmp/*-custom_resource_definition.tf ${DIR}/crd
# must manually add
#          "type": "object",
# to open_apiv3_schema

# Must apply the CRDs and then extract again
terraform fmt ${DIR}/crd

#https://kubernetes.io/docs/tasks/access-kubernetes-api/custom-resources/custom-resource-definitions/#publish-validation-schema-in-openapi-v2