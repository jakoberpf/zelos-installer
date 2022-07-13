resource "kubernetes_secret" "cloudflared_secret" {
  depends_on = [
    kubernetes_namespace.longhorn,
  ]

  metadata {
    name      = "erpf.de"
    namespace = "longhorn-system"
  }

  data = {
    "cert.pem" = var.cloudflared_certs.erpf.cert_pem
  }
}
