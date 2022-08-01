#!/usr/bin/env bash
GIT_ROOT=$(git rev-parse --show-toplevel)
cd $GIT_ROOT

# Kubernetes admin config
mkdir -p "$GIT_ROOT/.kube"
cd .kube

vault2env CICD/repo/zelos-bootstrap/live/kube-secret .env
source .env

echo "$admin_conf" | base64 --decode > admin.live.conf

rm .env
