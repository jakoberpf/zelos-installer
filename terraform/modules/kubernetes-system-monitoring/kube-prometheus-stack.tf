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

resource "kubectl_manifest" "monitoring" {
  yaml_body  = <<-EOF
---
apiVersion: traefik.containo.us/v1alpha1
kind: IngressRoute
metadata:
  name: grafana
spec:
  entryPoints:
    - websecure
  routes:
    - match: Host(`grafana.zelos.k8s.infra.erpf.de`) # Hostname to match
      kind: Rule
      services: # Service to redirect requests to
        - name: monitoring-grafana
          port: 80
  tls:
    secretName: grafana-erpf-de-tls
    
---
apiVersion: cert-manager.io/v1
kind: Certificate
metadata:
  name: grafana-erpf-de-tls
spec:
  secretName: grafana-erpf-de-tls
  issuerRef:
    name: cloudflare-letsencrypt-prod
    kind: ClusterIssuer
  commonName: grafana.zelos.k8s.infra.erpf.de
  dnsNames:
  - "grafana.zelos.k8s.infra.erpf.de"
  EOF

  depends_on = [
    kubernetes_namespace.monitoring,
    helm_release.monitoring
  ]
}
