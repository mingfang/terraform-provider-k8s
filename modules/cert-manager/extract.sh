#!/usr/bin/env bash

function tfextract() {
    go run cmd/extractor/*go $@
}

export DIR=modules/cert-manager
mkdir -p ${DIR}/tmp
mkdir -p ${DIR}/crd

# Must apply the CRDs before extraction

rm ${DIR}/tmp/*
tfextract -dir ${DIR}/tmp -url https://github.com/jetstack/cert-manager/releases/download/v0.10.0/cert-manager-no-webhook.yaml
rm ${DIR}/tmp/*-custom_resource_definition.tf
rm ${DIR}/tmp/*namespace.tf
mv ${DIR}/tmp/* ${DIR}

sed -i -e 's|namespace *= "cert-manager"|namespace = var.namespace|g' ${DIR}/*tf

#sed -i -e 's|namespace *= "metallb-system"|namespace = k8s_core_v1_service_account.speaker.metadata.0.namespace|g' ${DIR}/metallb-system_speaker-cluster_role_binding.tf

terraform fmt ${DIR}

#https://kubernetes.io/docs/tasks/access-kubernetes-api/custom-resources/custom-resource-definitions/#publish-validation-schema-in-openapi-v2