terraform {
  backend "s3" {
    bucket         = "hashicorp-terraform-backend"
    key            = "jakoberpf/zelos-installer/live/terraform.tfstate"
    region         = "eu-central-1"
    encrypt        = true
    kms_key_id     = "f066dc61-8dbe-4bbb-b4fe-1171fa476a4c"
    dynamodb_table = "tf-remote-state-lock"
  }
  required_providers {
    github = {
      source  = "integrations/github"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
    }
    kubectl = {
      source  = "gavinbunney/kubectl"
    }
    kustomization = {
      source  = "kbst/kustomization"
    }
    helm = {
      source  = "hashicorp/helm"
    }
    flux = {
      source  = "fluxcd/flux"
    }
    tls = {
      source  = "hashicorp/tls"
    }
  }
}

provider "flux" {}

provider "kubectl" {}

provider "kustomization" {
  kubeconfig_path = "${path.root}/../.kube/admin.${var.stage}.conf"
}

provider "kubernetes" {
  config_path = "${path.root}/../.kube/admin.${var.stage}.conf"
}

provider "helm" {
  kubernetes {
    config_path = "${path.root}/../.kube/admin.${var.stage}.conf"
  }
}

provider "github" {
  owner = var.github_owner
  token = var.github_token
}
