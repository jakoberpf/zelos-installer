module "zelos_system_service_cert_manager" {
  source            = "./modules/kubernetes-system-cert-manager"
  cloudflare_tokens = var.cloudflare_tokens
}

module "zelos_system_service_traefik" {
  source = "./modules/kubernetes-system-traefik"
  depends_on = [
    module.zelos_system_service_cert_manager
  ]
}

module "zelos_system_service_longhorn" {
  source = "./modules/kubernetes-system-longhorn"
  depends_on = [
    module.zelos_system_service_traefik
  ]
  gatekeeper_client_id       = var.longhorn_gatekeeper_client_id
  gatekeeper_client_secret   = var.longhorn_gatekeeper_client_secret
  gatekeeper_encryption_key  = var.longhorn_gatekeeper_encryption_key
  gatekeeper_redirection_url = var.longhorn_gatekeeper_redirection_url
  gatekeeper_discovery_url   = var.longhorn_gatekeeper_discovery_url
}

module "zelos_system_service_monitoring" {
  source = "./modules/kubernetes-system-monitoring"
  depends_on = [
    module.zelos_system_service_traefik
  ]
}

module "zelos_system_service_flux" {
  source = "./modules/kubernetes-system-flux"
  depends_on = [
    module.zelos_system_service_traefik,
    module.zelos_system_service_longhorn
  ]
  github_owner    = var.github_owner
  github_token    = var.github_token
  repository_name = var.repository_name
  branch          = var.branch
  stage           = var.stage
}

# module "zelos_system_service_argocd" {
#   source = "./modules/kubernetes-system-argocd"
#   depends_on = [
#     module.zelos_system_service_traefik,
#     module.zelos_system_service_longhorn
#   ]
# }
