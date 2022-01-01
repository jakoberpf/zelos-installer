resource "kubernetes_namespace" "argocd" {
  metadata {
    annotations = {
      name = "argocd-system"
    }

    labels = {
      managed-by = "artemis-installer"
    }

    name = "argocd-system"
  }
}

resource "helm_release" "argocd" {
  name       = "argocd"
  repository = "https://argoproj.github.io/argo-helm"
  chart      = "argo-cd"
  version    = "3.29.4"
  namespace  = "argocd-system"

  set {
    name  = "global.image.repository"
    value = "alinbalutoiu/argocd"
  }

  depends_on = [
    kubernetes_namespace.argocd,
  ]
}

# resource "kubectl_manifest" "ingressroute" {
#   yaml_body = <<-EOF
# ---
# apiVersion: traefik.containo.us/v1alpha1
# kind: IngressRoute
# metadata:
#   name: longhorn-dashboard
#   namespace: longhorn-system
# spec:
#   entryPoints:
#     - websecure
#   routes:
#     - match: Host(`longhorn.zelos.k8s.infra.erpf.de`) # Hostname to match
#       kind: Rule
#       services: # Service to redirect requests to
#         - name: longhorn-frontend
#           port: 80
#   tls:
#     secretName: longhorn-erpf-de-tls
#   EOF

#   depends_on = [
#     kubernetes_namespace.longhorn,
#     helm_release.longhorn,
#     kubectl_manifest.certificate
#   ]
# }

# resource "kubectl_manifest" "certificate" {
#   yaml_body = <<-EOF
# ---
# apiVersion: cert-manager.io/v1
# kind: Certificate
# metadata:
#   name: longhorn-erpf-de-tls
#   namespace: longhorn-system
# spec:
#   secretName: longhorn-erpf-de-tls
#   issuerRef:
#     name: cloudflare-letsencrypt-prod
#     kind: ClusterIssuer
#   commonName: longhorn.zelos.k8s.infra.erpf.de
#   dnsNames:
#   - "longhorn.zelos.k8s.infra.erpf.de"
#   EOF

#   depends_on = [
#     kubernetes_namespace.longhorn,
#     helm_release.longhorn
#   ]
# }
