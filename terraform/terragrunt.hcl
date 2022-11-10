locals {
  vars_yaml = yamldecode(file("terragrunt.yaml"))
  terraform = local.vars_yaml.terraform
}

terraform {
    extra_arguments "custom_vars" {
    commands = [
      "apply",
      "plan",
      "import",
      "push",
      "refresh"
    ]
    required_var_files = ["${get_parent_terragrunt_dir()}/variables.tfvars"]
  }
}

generate "backend" {
  path      = "generated.backend.tf"
  if_exists = "overwrite_terragrunt"
  contents = <<EOF
terraform {
  backend "s3" {
    bucket         = "${local.terraform.backend.bucket}"
    key            = "${local.terraform.backend.key}"
    region         = "${local.terraform.backend.region}"
    encrypt        = true
    kms_key_id     = "${local.terraform.backend.kms_key_id}"
    dynamodb_table = "${local.terraform.backend.dynamodb_table}"
  }
  required_providers {
    github = {
      source = "integrations/github"
    }
    kubernetes = {
      source = "hashicorp/kubernetes"
    }
    kubectl = {
      source = "gavinbunney/kubectl"
    }
    kustomization = {
      source = "kbst/kustomization"
    }
    helm = {
      source = "hashicorp/helm"
    }
    flux = {
      source = "fluxcd/flux"
    }
    tls = {
      source = "hashicorp/tls"
    }
  }
}
EOF
}
