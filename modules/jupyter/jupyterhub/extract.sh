#!/usr/bin/env bash

alias tfextract='go run cmd/extractor/*go'

export DIR=modules/jupyter/jupyterhub

mkdir -p ${DIR}/jupyterhub/extract

helm template ${DIR}/jupyterhub \
  --set proxy.secretToken=`openssl rand -hex 32` \
  --set hub.cookieSecret=`openssl rand -hex 32` \
  --set prePuller.hook.enabled="false" \
  --set prePuller.continuous.enabled="false" \
  --set scheduling.userScheduler.enabled="false" \
  --set scheduling.userPlaceholder.enabled="false" \
  --set hub.db.type="sqlite" \
  --set singleuser.storage.type="static" \
  --set singleuser.defaultUrl="/lab" \
  --set hub.extraConfig.jupyterlab="c.Spawner.cmd = ['jupyter-labhub']" \
  --namespace='${var.namespace}' \
  --set singleuser.image.name='${var.singleuser_image_name}' \
  --set singleuser.image.tag='${var.singleuser_image_tag}' \
  --set singleuser.storage.static.pvcName='${var.singleuser_storage_static_pvcName}' \
  > ${DIR}/jupyterhub/extract/jupyterhub.yaml

tfextract -dir ${DIR}/jupyterhub/extract -f ${DIR}/jupyterhub/extract/jupyterhub.yaml
sed -i -e 's|$${|${|g' ${DIR}/jupyterhub/extract/hub-config-config_map.tf

terraform fmt -recursive ${DIR}/jupyterhub/extract

#manually copy the data from modules/jupyter/jupyterhub/jupyterhub/extract/hub-config-config_map.tf to modules/jupyter/jupyterhub/config/config_map.tf