module "zelos_system_service_cert_manager" {
  source = "${path.module}/modules/kubernetes-system-cert-manager"
  providers = {
    kubernetes = kubernetes
  }
}

module "zelos_system_service_metallb" {
  source = "${path.module}/modules/kubernetes-system-longhorn"
  providers = {
    kubernetes = kubernetes
  }
}

module "zelos_system_service_traefik" {
  source = "${path.module}/modules/kubernetes-system-traefik"
  depends_on = [
    module.zelos_system_service_metallb
  ]
  providers = {
    kubernetes = kubernetes
  }
}

module "zelos_system_service_longhorn" {
  source = "${path.module}/modules/kubernetes-system-longhorn"
  depends_on = [
    module.zelos_system_service_traefik
  ]
  providers = {
    kubernetes = kubernetes
  }
}