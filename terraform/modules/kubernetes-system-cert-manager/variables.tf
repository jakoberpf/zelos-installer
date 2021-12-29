variable "cloudflare_tokens" {
  type = map(object({
          name  = string
          host = string
          domain  = string
          token = string
         }))
  description = "The API tokens for the cloudflare zones"
}