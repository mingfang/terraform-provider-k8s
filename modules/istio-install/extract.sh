#!/usr/bin/env bash

mkdir -p modules/istio/crd
mkdir -p modules/istio-install/install

alias tfextract='go run cmd/extractor/*go'
VERSION="1.1.2"

#must extract and apply CRDs first

tfextract -dir modules/istio/crd -file modules/istio-install/istio-${VERSION}/install/kubernetes/helm/istio-init/files/crd-10.yaml

tfextract -dir modules/istio/crd -file modules/istio-install/istio-${VERSION}/install/kubernetes/helm/istio-init/files/crd-11.yaml


tfextract -dir modules/istio/crd -f modules/istio-install/istio-${VERSION}/install/kubernetes/helm/istio-init/files/crd-certmanager-10.yaml

tfextract -dir modules/istio/crd -f modules/istio-install/istio-${VERSION}/install/kubernetes/helm/istio-init/files/crd-certmanager-11.yaml

#extract demo
tfextract -dir modules/istio-install/install -f modules/istio-install/istio-${VERSION}/install/kubernetes/istio-demo.yaml

#remove dup crds
rm modules/istio-install/install/*custom_resource_definition.tf

#fix non-namespaced resource
sed  -i -e 's|namespace = "istio-system"||' modules/istio-install/install/*-mutating_webhook_configuration.tf

#namespace
sed -i -e 's|namespace = "istio-system"|namespace = "${var.namespace}"|g' modules/istio-install/install/*.tf
sed -i -e 's| istio-system| ${var.namespace}|g' modules/istio-install/install/*.tf
sed -i -e 's|=istio-system|=${var.namespace}|g' modules/istio-install/install/*.tf
sed -i -e 's|\\"istio-system\\"|\\"${var.namespace}\\"|g' modules/istio-install/install/*.tf
sed -i -e 's|istio-system\.svc|${var.namespace}.svc|g' modules/istio-install/install/*.tf
sed -i -e 's|zipkin\.istio-system|zipkin.${var.namespace}|g' modules/istio-install/install/*.tf
sed -i -e 's|istio-pilot\.istio-system|istio-pilot.${var.namespace}|g' modules/istio-install/install/*.tf

#loadbalancer
sed -i -e 's|type = "LoadBalancer"|type = "${var.type}"|g' modules/istio-install/install/*.tf

#fix resources
sed -i -e 's|"2000m"|"2"|g' modules/istio-install/install/*.tf
sed -i -e 's|"2048Mi"|"2Gi"|g' modules/istio-install/install/*.tf

#move files according to their app label
grep -o -h '"chart" *= ".*"' modules/istio-install/install/*tf \
  | uniq | awk -F '"' '{printf "%s\n%s\n", $0, $4}' \
  | xargs -d '\n' -n 2 -r sh -cx \
      'mkdir -p modules/istio/$1; grep -l "$0" modules/istio-install/install/*tf | xargs -r -I{} mv {} modules/istio/$1'

#istio
mv modules/istio-install/install/istio-reader-cluster_role.tf modules/istio/istio-1.1.0
mv modules/istio-install/install/istio-multi-*.tf modules/istio/istio-1.1.0

#mixer
mv modules/istio-install/install/promtcpconnection*.tf modules/istio/mixer
mv modules/istio-install/install/tcpconnections*.tf modules/istio/mixer

#ingressgateway
mv modules/istio-install/install/*ingressgateway*.tf modules/istio/gateways

