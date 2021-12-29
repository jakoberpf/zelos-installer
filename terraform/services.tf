module "zelos_system_service_cert_manager" {
  source = "./modules/kubernetes-system-cert-manager"
  cloudflare_tokens = var.cloudflare_tokens
}

module "zelos_system_service_traefik" {
  source = "./modules/kubernetes-system-traefik"
  depends_on = [
    module.zelos_system_service_cert_manager
  ]
}

# module "zelos_system_service_longhorn" {
#   source = "${path.module}/modules/kubernetes-system-longhorn"
#   depends_on = [
#     module.zelos_system_service_traefik
#   ]
#   providers = {
#     kubernetes = kubernetes
#   }
# }