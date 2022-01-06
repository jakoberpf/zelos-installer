data "flux_sync" "main" {
  target_path = "${var.stage}/fluxcd"
  url         = "ssh://git@github.com/${var.github_owner}/${var.repository_name}.git"
  branch      = "main"
}

data "kubectl_file_documents" "sync" {
  content = data.flux_sync.main.content
}

# Apply manifests on the cluster
resource "kubectl_manifest" "sync" {
  depends_on = [
    kubectl_manifest.apply
  ]
  for_each  = data.kubectl_file_documents.sync.manifests
  yaml_body = each.value
}
