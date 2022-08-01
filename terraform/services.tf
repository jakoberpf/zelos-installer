module "zelos_system_service_external_secrets" {
  source = "/Users/jakoberpf/Code/jakoberpf/terraform/modules/kubernetes/external-secrets-deployment" # "jakoberpf/external-secrets-deployment/kubernetes"

  compartment = "zelos-installer"

  vault_server = var.vault_server
  vault_token  = var.vault_token
}

module "zelos_system_service_cert_manager" {
  source = "jakoberpf/certmanager-deployment/kubernetes"

  # compartment = "athena-installer"

  deploy_manager    = true # TODO remove and make default
  deploy_reflector  = true # TODO remove and make default
  cloudflare_tokens = var.cloudflare_tokens
}

module "zelos_system_service_longhorn" {
  depends_on = [
    module.zelos_system_service_cert_manager
  ]

  source = "/Users/jakoberpf/Code/jakoberpf/terraform/modules/kubernetes/longhorn-deployment" # "jakoberpf/longhorn-deployment/kubernetes"

  compartment = "zelos-installer"

  aws_access_key_id     = var.longhorn_aws_access_key_id
  aws_secret_access_key = var.longhorn_aws_secret_access_key

  ingress_dns = var.longhorn_ingress_dns

  gatekeeper_client_id       = var.longhorn_gatekeeper_client_id
  gatekeeper_client_secret   = var.longhorn_gatekeeper_client_secret
  gatekeeper_encryption_key  = var.longhorn_gatekeeper_encryption_key
  gatekeeper_redirection_url = var.longhorn_gatekeeper_redirection_url
  gatekeeper_discovery_url   = var.longhorn_gatekeeper_discovery_url
}

# module "zelos_system_service_flux" {
#   source = "jakoberpf/flux-deployment/kubernetes"

#   github_owner    = var.github_owner
#   github_token    = var.github_token
#   repository_name = var.repository_name
#   branch          = var.branch
#   stage           = var.stage
# }
