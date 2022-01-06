data "flux_install" "main" {
  target_path    = "${var.stage}/fluxcd"
  network_policy = false
  version        = "latest"
}

data "kubectl_file_documents" "apply" {
  content = data.flux_install.main.content
}

# Apply manifests on the cluster
resource "kubectl_manifest" "apply" {
  for_each  = data.kubectl_file_documents.apply.manifests
  yaml_body = each.value
}
