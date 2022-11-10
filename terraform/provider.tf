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
