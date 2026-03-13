variable "addon_version" {
  type        = string
  description = "(Required) EKS-managed add-on version."
  nullable    = false
}

variable "cluster_name" {
  type        = string
  description = "(Required) Host EKS Cluster name."
  nullable    = false
}

variable "name" {
  type        = string
  description = "(Required) EKS-managed add-on name."
  nullable    = false
}


variable "cluster_oidc" {
  type = object({
    arn = string
    url = string
  })
  description = <<-EOT
    (Optional) Host EKS Cluster IAM OIDC Provider details (necessary for add-ons with IRSA config requirements).

    Attributes:
      - arn: (Required) IAM OIDC provider ARN.
      - url: (Required) IAM OIDC provider URL.
  EOT
  nullable    = false
  default = {
    arn = null
    url = null
  }
}

variable "configuration_values" {
  type        = string
  description = <<-EOT
    (Optional) EKS-managed add-on configuration values JSON string.

    NOTE: This map must match the JSON schema derived from 'aws eks describe-addon-configuration' as it will be used
    with the Terraform 'jsonencode()' function when configuring the add-on resource.
  EOT
  default     = null
  nullable    = true
}

variable "tags" {
  type        = map(string)
  description = <<-EOT
    (Optional) Key-value map of resource tags to be applied to all taggable resources within this module.

    If also configured with 'provider.default_tags' in the root module, tags with matching keys here will override
    those defined at the provider-level.
  EOT
  default     = {}
  nullable    = false
}

variable "timeouts" {
  type = object({
    create = optional(string)
    update = optional(string)
    delete = optional(string)
  })
  description = <<-EOT
    (Optional) EKS Add-on timeouts configuration determining how long to wait for create, update, and delete operations.
  EOT
  default = {
    create = "20m"
    update = "20m"
    delete = "40m"
  }
  nullable = false
}
