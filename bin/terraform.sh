#!/usr/bin/env bash
GIT_ROOT=$(git rev-parse --show-toplevel)
cd $GIT_ROOT

# Run terraform apply
cd $GIT_ROOT/terraform
terraform init -upgrade
terraform apply -var-file="variables.tfvars"
# tf apply -var-file="variables.tfvars" -target=module.zelos_system_service_longhorn
cd $GIT_ROOT