#!/usr/bin/env bash

alias tfextract='go run cmd/extractor/*go'

export DIR=modules/metallb

tfextract -dir ${DIR} -url https://raw.githubusercontent.com/google/metallb/v0.7.3/manifests/metallb.yaml

rm ${DIR}/*namespace.tf

sed -i -e 's|namespace *= "metallb-system"|namespace = k8s_core_v1_service_account.speaker.metadata.0.namespace|g' ${DIR}/metallb-system_speaker-cluster_role_binding.tf
sed -i -e 's|namespace *= "metallb-system"|namespace = var.namespace|g' ${DIR}/*tf
sed -i -e 's|k8s_apps_v1beta2_deployment|k8s_apps_v1_deployment|g' ${DIR}/*tf
sed -i -e 's|k8s_apps_v1beta2_daemon_set|k8s_apps_v1_daemon_set|g' ${DIR}/*tf

terraform fmt ${DIR}