resource "kubernetes_namespace" "monitoring" {
  metadata {
    annotations = {
      name = "monitoring-system"
    }
    labels = {
      managed-by = "zelos-installer"
    }
    name = "monitoring-system"
  }
}

resource "helm_release" "monitoring" {
  name       = "kube-prometheus-stack"
  repository = "https://prometheus-community.github.io/helm-charts"
  chart      = "kube-prometheus-stack"
  version    = "20.0.1"
  namespace  = "monitoring-system"

  depends_on = [
    kubernetes_namespace.monitoring,
  ]
}

data "kubectl_path_documents" "monitoring" {
  pattern = "${path.module}/kubernetes/*.yaml"
  vars = {
      namespace = "monitoring"
  }
}

resource "kubectl_manifest" "monitoring" {
  for_each  = toset(data.kubectl_path_documents.monitoring.documents)
  yaml_body = each.value
  depends_on = [
    kubernetes_namespace.monitoring,
    helm_release.monitoring
  ]
}
