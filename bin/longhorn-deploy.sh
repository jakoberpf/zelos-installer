#!/usr/bin/env bash
GIT_ROOT=$(git rev-parse --show-toplevel)
cd $GIT_ROOT

LONGHORN_VERSION="1.4.0"

LONGHORN_NAMESPACE=storage-longhorn
if [ ! "$(kubectl get namespaces -o json | jq -r ".items[].metadata.name | select (. == \"$LONGHORN_NAMESPACE\")")" == "$LONGHORN_NAMESPACE" ]; then
    echo "Creating namespace $LONGHORN_NAMESPACE"
    kubectl create namespace $LONGHORN_NAMESPACE
else
    echo "Namespace $LONGHORN_NAMESPACE exists, nothing to do"
fi

helm repo add longhorn https://charts.longhorn.io
helm repo update

# helm upgrade --install prometheus-stack prometheus-community/kube-prometheus-stack -f configs/prometheus-stack-values.yaml -n $PROMETHEUS_NAMESPACE
