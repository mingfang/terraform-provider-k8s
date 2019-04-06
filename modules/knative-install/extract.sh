#!/usr/bin/env bash

alias tfextract='go run cmd/extractor/*go'
VERSION="v0.5.0"

# must extract CRD first and then apply both Knative and Istio CRDs first
mkdir -p modules/knative/crd
tfextract -dir modules/knative/crd -kind CustomResourceDefinition -url https://github.com/knative/serving/releases/download/${VERSION}/serving.yaml

mkdir -p modules/knative/serving
tfextract -dir modules/knative/serving -url https://github.com/knative/serving/releases/download/${VERSION}/serving.yaml
tfextract -dir modules/knative/serving -url https://raw.githubusercontent.com/knative/serving/${VERSION}/third_party/config/build/clusterrole.yaml
sed -i -e 's|namespace *= ".*"|namespace = "${var.namespace}"|g' modules/knative/serving/*.tf
sed -i -e 's|"1000m"|"1"|g' modules/knative/serving/*.tf
rm modules/knative/serving/*custom_resource_definition.tf
rm modules/knative/serving/*namespace.tf