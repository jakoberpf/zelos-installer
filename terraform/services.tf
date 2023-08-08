module "external_secrets" {
  source = "jakoberpf/external-secrets-deployment/kubernetes"

  helm_chart_version = "0.7.2"
  compartment        = "zelos-installer"
  vault_server       = var.vault_server
  vault_token        = var.vault_token
}

module "cert_manager" {
  source = "jakoberpf/certmanager-deployment/kubernetes"

  helm_chart_version_manager   = "1.11.0"
  helm_chart_version_reflector = "6.1.47"
  compartment                  = "zelos-installer"
  cloudflare_tokens            = var.cloudflare_tokens
}

module "longhorn" {
  source = "jakoberpf/longhorn-deployment/kubernetes"

  compartment                = "zelos-installer"
  helm_chart_version         = "1.4.0"
  aws_access_key_id          = var.longhorn_aws_access_key_id
  aws_secret_access_key      = var.longhorn_aws_secret_access_key
  ingress_dns                = var.longhorn_ingress_dns
  ingress_type               = "istio"
  gatekeeper_client_id       = var.longhorn_gatekeeper_client_id
  gatekeeper_client_secret   = var.longhorn_gatekeeper_client_secret
  gatekeeper_encryption_key  = var.longhorn_gatekeeper_encryption_key
  gatekeeper_redirection_url = var.longhorn_gatekeeper_redirection_url
  gatekeeper_discovery_url   = var.longhorn_gatekeeper_discovery_url

  depends_on = [
    module.cert_manager
  ]
}

module "argo" {
  source = "jakoberpf/argo-deployment/kubernetes"

  compartment = "zelos-installer"
}

# module "flux" {
#   source = "jakoberpf/flux-deployment/kubernetes"

#   github_owner    = var.github_owner
#   github_token    = var.github_token
#   repository_name = var.repository_name
#   branch          = var.branch
#   stage           = var.stage
# }
