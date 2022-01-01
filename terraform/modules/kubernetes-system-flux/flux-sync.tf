data "flux_sync" "main" {
  target_path = "${var.stage}/fluxcd"
  url         = "ssh://git@github.com/${var.github_owner}/${var.repository_name}.git"
  branch      = "main"
}

data "kubectl_file_documents" "sync" {
  content = data.flux_sync.main.content
}

locals {
  sync = [for v in data.kubectl_file_documents.sync.documents : {
    data : yamldecode(v)
    content : v
    }
  ]
}

resource "kubectl_manifest" "sync" {
  for_each = { for v in local.sync : lower(join("/", compact([v.data.apiVersion, v.data.kind, lookup(v.data.metadata, "namespace", ""), v.data.metadata.name]))) => v.content }
  depends_on = [
    kubernetes_namespace.flux_system
  ]
  yaml_body = each.value
}
