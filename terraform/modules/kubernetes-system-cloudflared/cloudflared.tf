resource "kubernetes_namespace" "cloudflare" {
  metadata {
    annotations = {
      name = "cloudflare-system"
    }

    labels = {
      managed-by = "zelos-installer"
    }

    name = "cloudflare-system"
  }
}

# resource "helm_release" "cloudflare" {
#   name       = "argo-tunnel"
#   repository = "https://cloudflare.github.io/helm-charts"
#   chart      = "argo-tunnel"
#   version    = "0.6.5"
#   namespace  = "cloudflare-system"

#   depends_on = [
#     kubernetes_namespace.cloudflare,
#   ]
# }
