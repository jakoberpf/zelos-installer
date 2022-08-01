terraform {
  backend "s3" {}
  required_version = ">= 1.0.0"
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
