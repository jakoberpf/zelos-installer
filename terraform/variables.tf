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

variable "repository_visibility" {
  type        = string
  default     = "private"
  description = "How visiable is the github repo"
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
