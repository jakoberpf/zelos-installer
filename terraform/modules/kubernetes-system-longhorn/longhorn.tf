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

resource "kubectl_manifest" "longhorn" {
  yaml_body  = <<-EOF
---
apiVersion: traefik.containo.us/v1alpha1
kind: IngressRoute
metadata:
  name: longhorn-dashboard
  namespace: longhorn-system
spec:
  entryPoints:
    - websecure
  routes:
    - match: Host(`longhorn.zelos.k8s.infra.erpf.de`) # Hostname to match
      kind: Rule
      services: # Service to redirect requests to
        - name: longhorn-frontend
          port: 80
      # middlewares:
      #   - name: longhorn-basic-auth
  tls:
    secretName: longhorn-erpf-de-tls
    
---
apiVersion: cert-manager.io/v1
kind: Certificate
metadata:
  name: longhorn-erpf-de-tls
  namespace: longhorn-system
spec:
  secretName: longhorn-erpf-de-tls
  issuerRef:
    name: cloudflare-letsencrypt-prod
    kind: ClusterIssuer
  commonName: longhorn.zelos.k8s.infra.erpf.de
  dnsNames:
  - "longhorn.zelos.k8s.infra.erpf.de"
  EOF

  depends_on = [
    kubernetes_namespace.longhorn,
    helm_release.longhorn
  ]
}
