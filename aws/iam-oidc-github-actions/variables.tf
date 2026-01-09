variable "tags" {
  type        = map(string)
  description = <<-EOT
    (Optional) Key-value map of resource tags to be applied to all taggable resources within this module.

    If also configured with 'provider.default_tags' in the root module, tags with matching keys here will overwrite
    those defined at the provider-level.
  EOT
  default     = {}
}
