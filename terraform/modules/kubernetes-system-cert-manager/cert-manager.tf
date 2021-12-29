resource "kubernetes_namespace" "cert_manager" {
  metadata {
    annotations = {
      name = "cert-manager"
    }

    labels = {
      managed-by = "zelos-installer"
    }

    name = "cert-manager"
  }
}

resource "helm_release" "cert_manager" {
  name       = "cert-manager"
  repository = "https://charts.jetstack.io"
  chart      = "cert-manager"
  version    = "1.6.1"
  namespace  = "cert-manager"

  set {
    name  = "installCRDs"
    value = "true"
  }

  depends_on = [
    kubernetes_namespace.cert_manager,
  ]
}

data "kubectl_path_documents" "cert_manager" {
  pattern = "${path.module}/kubernetes/cert-manager/*.yaml"
  vars = {
      namespace = "cart-manager"
  }
  sensitive_vars = {
    cloudflare-api-token = var.cloudflare_tokens["erpf"].token
  }
}

resource "kubectl_manifest" "cert_manager" {
  for_each  = toset(data.kubectl_path_documents.cert_manager.documents)
  yaml_body = each.value
  sensitive_fields = [
      "stringData.token"
  ]
  depends_on = [
    helm_release.cert_manager,
  ]
}