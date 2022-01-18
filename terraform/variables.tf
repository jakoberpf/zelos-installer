variable "github_owner" {
  type        = string
  description = "github owner"
}

variable "github_token" {
  type        = string
  description = "github token"
}

variable "repository_name" {
  type        = string
  description = "github repository name"
}

variable "branch" {
  type        = string
  default     = "main"
  description = "branch name"
}

variable "stage" {
  type        = string
  default     = "live"
  description = "stage [dev|live]"
}

variable "cloudflare_tokens" {
  type = map(object({
          name  = string
          host = string
          domain  = string
          token = string
         }))
  description = "The API tokens for the cloudflare zones"
}

variable "longhorn_gatekeeper_client_id" {
  type        = string
  description = ""
}

variable "longhorn_gatekeeper_client_secret" {
  type        = string
  description = ""
}

variable "longhorn_gatekeeper_encryption_key" {
  type        = string
  description = ""
}

variable "longhorn_gatekeeper_redirection_url" {
  type        = string
  description = ""
}

variable "longhorn_gatekeeper_discovery_url" {
  type        = string
  description = ""
}
