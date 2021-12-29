terraform {
  required_version = ">= 0.13"
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
      version = ">= 4.9.3"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = ">= 2.0.2"
    }
    kubectl = {
      source  = "gavinbunney/kubectl"
      version = ">= 1.10.0"
    }
    kustomization = {
      source  = "kbst/kustomization"
      version = "0.7.0"
    }
    helm = {
      source  = "hashicorp/helm"
      version = ">= 2.4.1"
    }
    flux = {
      source  = "fluxcd/flux"
      version = ">= 0.0.13"
    }
    tls = {
      source  = "hashicorp/tls"
      version = "3.1.0"
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
