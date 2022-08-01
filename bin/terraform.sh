#!/usr/bin/env bash
GIT_ROOT=$(git rev-parse --show-toplevel)
cd $GIT_ROOT

# Run terraform apply
cd $GIT_ROOT/terraform
terragrunt init -backend-config=backend.conf -upgrade
terragrunt apply
cd $GIT_ROOT