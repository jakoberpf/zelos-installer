#!/usr/bin/env bash
GIT_ROOT=$(git rev-parse --show-toplevel)
cd $GIT_ROOT

PROMETHEUS_OPERATOR_VERSION="v0.63.0"

PROMETHEUS_NAMESPACE=kube-monitoring
if [ ! "$(kubectl get namespaces -o json | jq -r ".items[].metadata.name | select (. == \"$PROMETHEUS_NAMESPACE\")")" == "$PROMETHEUS_NAMESPACE" ]; then
    echo "Creating namespace $PROMETHEUS_NAMESPACE"
    kubectl create namespace $PROMETHEUS_NAMESPACE
else
    echo "Namespace $PROMETHEUS_NAMESPACE exists, nothing to do"
fi

# kubectl apply --server-side -f https://raw.githubusercontent.com/prometheus-operator/prometheus-operator/v0.63.0/example/prometheus-operator-crd/monitoring.coreos.com_alertmanagerconfigs.yaml
# kubectl apply --server-side -f https://raw.githubusercontent.com/prometheus-operator/prometheus-operator/v0.63.0/example/prometheus-operator-crd/monitoring.coreos.com_alertmanagers.yaml
# kubectl apply --server-side -f https://raw.githubusercontent.com/prometheus-operator/prometheus-operator/v0.63.0/example/prometheus-operator-crd/monitoring.coreos.com_podmonitors.yaml
# kubectl apply --server-side -f https://raw.githubusercontent.com/prometheus-operator/prometheus-operator/v0.63.0/example/prometheus-operator-crd/monitoring.coreos.com_probes.yaml
# kubectl apply --server-side -f https://raw.githubusercontent.com/prometheus-operator/prometheus-operator/v0.63.0/example/prometheus-operator-crd/monitoring.coreos.com_prometheuses.yaml
# kubectl apply --server-side -f https://raw.githubusercontent.com/prometheus-operator/prometheus-operator/v0.63.0/example/prometheus-operator-crd/monitoring.coreos.com_prometheusrules.yaml
# kubectl apply --server-side -f https://raw.githubusercontent.com/prometheus-operator/prometheus-operator/v0.63.0/example/prometheus-operator-crd/monitoring.coreos.com_servicemonitors.yaml
# kubectl apply --server-side -f https://raw.githubusercontent.com/prometheus-operator/prometheus-operator/v0.63.0/example/prometheus-operator-crd/monitoring.coreos.com_thanosrulers.yaml

# kubectl delete crd alertmanagerconfigs.monitoring.coreos.com
# kubectl delete crd alertmanagers.monitoring.coreos.com
# kubectl delete crd podmonitors.monitoring.coreos.com
# kubectl delete crd probes.monitoring.coreos.com
# kubectl delete crd prometheuses.monitoring.coreos.com
# kubectl delete crd prometheusrules.monitoring.coreos.com
# kubectl delete crd servicemonitors.monitoring.coreos.com
# kubectl delete crd thanosrulers.monitoring.coreos.com

helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo update

helm upgrade --install prometheus-stack prometheus-community/kube-prometheus-stack \
    -f configs/prometheus-stack-values.yaml \
    -f configs/prometheus-stack-values-secret.yaml \
    -n $PROMETHEUS_NAMESPACE

helm upgrade --install prometheus-adapter prometheus-community/prometheus-adapter \
    -f configs/prometheus-adapter-values.yaml \
    -n $PROMETHEUS_NAMESPACE

kubectl apply -f configs/prometheus-stack-istio.yaml -n $PROMETHEUS_NAMESPACE

# https://medium.com/@akashjoffical08/monitor-uptime-of-endpoints-in-k8s-using-blackbox-exporter-f80166a328e9
# - name: prometheus-blackbox-exporter
#   repo: https://prometheus-community.github.io/helm-charts
# - name: kubewatch
#   repo: https://charts.bitnami.com/bitnami
