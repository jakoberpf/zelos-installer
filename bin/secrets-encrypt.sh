#!/usr/bin/env bash
GIT_ROOT=$(git rev-parse --show-toplevel)
cd $GIT_ROOT

sops --encrypt --input-type yaml --output-type yaml terraform/terragrunt.yaml > terraform/terragrunt.yaml.enc
sops --encrypt terraform/variables.tfvars > terraform/variables.tfvars.enc

sops --encrypt configs/prometheus-stack-values-secret.yaml > configs/prometheus-stack-values-secret.yaml.enc
