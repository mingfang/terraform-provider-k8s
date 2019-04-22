#!/usr/bin/env bash

alias tfextract='go run cmd/extractor/*go'

export DIR=modules/jupyter/enterprise-gateway

mkdir -p ${DIR}/extract

tfextract -dir ${DIR} -f ${DIR}/extract/enterprise-gateway.yaml

rm ${DIR}/*namespace.tf
sed -i -e 's|namespace *= "enterprise-gateway"|namespace = k8s_core_v1_service.enterprise-gateway.metadata.0.namespace|g' ${DIR}/enterprise-gateway-controller-cluster_role_binding.tf
sed -i -e 's|namespace *= "enterprise-gateway"|namespace = var.namespace|g' ${DIR}/*.tf
sed -i -e 's|value *= "enterprise-gateway"|value = var.namespace|g' ${DIR}/*deployment.tf
sed -i -e 's|type *= "NodePort"||g' ${DIR}/*.tf
sed -i -e 's|image_pull_policy *= "IfNotPresent"|image_pull_policy = "Always"|g' ${DIR}/*.tf

terraform fmt -recursive ${DIR}