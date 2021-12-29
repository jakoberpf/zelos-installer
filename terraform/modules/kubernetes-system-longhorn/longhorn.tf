resource "kubernetes_namespace" "longhorn" {
  metadata {
    annotations = {
      name = "longhorn-system"
    }

    labels = {
      managed-by = "artemis-installer"
    }

    name = "longhorn-system"
  }
}

resource "helm_release" "longhorn" {
  name       = "longhorn"
  repository = "https://charts.longhorn.io"
  chart      = "longhorn"
  version    = "1.2.2"
  namespace  = "longhorn-system"

  depends_on = [
    kubernetes_namespace.longhorn,
  ]
}

data "kubectl_path_documents" "longhorn" {
  pattern = "${path.module}/kubernetes/longhorn/*.yaml"
  vars = {
      namespace = "longhorn"
  }
}

resource "kubectl_manifest" "longhorn" {
  for_each  = toset(data.kubectl_path_documents.longhorn.documents)
  yaml_body = each.value
  depends_on = [
    kubernetes_namespace.longhorn,
    helm_release.longhorn
  ]
}
