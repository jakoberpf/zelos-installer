resource "kubernetes_namespace" "traefik" {
  metadata {
    annotations = {
      name = "traefik"
    }

    labels = {
      managed-by = "zelos-installer"
    }

    name = "traefik"
  }
}

resource "helm_release" "traefik" {
  name       = "traefik"
  repository = "https://helm.traefik.io/traefik"
  chart      = "traefik"
  version    = "10.7.1"
  namespace  = "traefik"

  values = [
    "${file("${path.module}/kubernetes/traefik/values.yaml")}"
  ]

  depends_on = [
    kubernetes_namespace.traefik,
  ]
}
