module "zelos_system_service_cert_manager" {
  source = "jakoberpf/certmanager-deployment/kubernetes"

  cloudflare_tokens = var.cloudflare_tokens
}

module "zelos_system_service_traefik" {
  source = "jakoberpf/traefik-deployment/kubernetes"
  depends_on = [
    module.zelos_system_service_cert_manager
  ]
}

module "zelos_system_service_longhorn" {
  source = "jakoberpf/longhorn-deployment/kubernetes"
  depends_on = [
    module.zelos_system_service_traefik
  ]

  gatekeeper_client_id       = var.longhorn_gatekeeper_client_id
  gatekeeper_client_secret   = var.longhorn_gatekeeper_client_secret
  gatekeeper_encryption_key  = var.longhorn_gatekeeper_encryption_key
  gatekeeper_redirection_url = var.longhorn_gatekeeper_redirection_url
  gatekeeper_discovery_url   = var.longhorn_gatekeeper_discovery_url
  cloudflared_certs          = var.cloudflared_certs
}

module "zelos_system_service_monitoring" {
  source = "jakoberpf/monitoring-deployment/kubernetes"
  depends_on = [
    module.zelos_system_service_traefik
  ]

  grafana_adminPassword = var.grafana_adminPassword
  grafana_root_url      = var.grafana_root_url
  grafana_client_id     = var.grafana_client_id
  grafana_client_secret = var.grafana_client_secret
  grafana_auth_url      = var.grafana_auth_url
  grafana_token_url     = var.grafana_token_url
  grafana_api_url       = var.grafana_api_url
}

module "zelos_system_service_flux" {
  source = "jakoberpf/flux-deployment/kubernetes"

  github_owner    = var.github_owner
  github_token    = var.github_token
  repository_name = var.repository_name
  branch          = var.branch
  stage           = var.stage
}
