resource "kubernetes_namespace" "external_secrets" {
  metadata {
    annotations = {
      name = "external-secrets-system"
    }

    labels = {
      managed-by = "zelos-installer"
    }

    name = "external-secrets-system"
  }
}

resource "helm_release" "external_secrets" {
  name       = "kubernetes-external-secrets"
  repository = "https://external-secrets.github.io/kubernetes-external-secrets/"
  chart      = "external-secrets/kubernetes-external-secrets"
  version    = "8.5.0"
  namespace  = kubernetes_namespace.external_secrets.name

  set {
    name  = "env.VAULT_ADDR"
    value = var.vault_address
  }

  depends_on = [
    kubernetes_namespace.external_secrets,
  ]
}

# https://craftech.io/blog/manage-your-kubernetes-secrets-with-hashicorp-vault/
# https://github.com/external-secrets/kubernetes-external-secrets

# data "kubectl_path_documents" "external_secrets" {
#   pattern = "${path.module}/kubernetes/cert-manager/*.yaml"
#   vars = {
#       namespace = "cart-manager"
#   }
#   sensitive_vars = {
#     cloudflare-api-token = var.cloudflare_tokens["erpf"].token
#   }
# }

# resource "kubectl_manifest" "external_secrets" {
#   for_each  = toset(data.kubectl_path_documents.external_secrets.documents)
#   yaml_body = each.value
#   sensitive_fields = [
#       "stringData.token"
#   ]
#   depends_on = [
#     helm_release.external_secrets,
#   ]
# }
