variable "description" {
  type        = string
  description = <<-EOT
    (Required) GitHub Actions IAM Role description.

    NOTE: IAM Roles created by this module will always have the following description prefix: 'GitHub Actions Role:: '.
  EOT
  nullable    = false
}

variable "iam_oidc_provider_arn" {
  type        = string
  description = "(Required) GitHub Actions IAM OIDC Provider ARN."
  nullable    = false
}

variable "repo_authorization_scopes" {
  type        = list(string)
  description = <<-EOT
    (Required) List of GitHub authorization scopes permitting access to assume the GitHub Actions IAM Role.

    see: https://docs.github.com/en/actions/how-tos/secure-your-work/security-harden-deployments/oidc-in-aws#configuring-the-role-and-trust-policy
  EOT
  nullable    = false
}


variable "path" {
  type        = string
  description = <<-EOT
    (Optional) GitHub Actions IAM Role URI path.

    Note: Leaving this unset (default '/') is recommended when creating IAM Roles to apply / install Helm charts for EKS
    due to downstream EKS IAM Authenticator bugs when using non-default IAM Resource Paths.
  EOT
  nullable    = false
  default     = "/"
}

variable "name" {
  type        = string
  description = <<-EOT
    (Optional) GitHub Actions IAM Role name.

    Note: If omitted, Terraform will assign a random, unique name.
  EOT
  nullable    = true
  default     = null
}

variable "name_prefix" {
  type        = string
  description = <<-EOT
    (Optional) GitHub Actions IAM Role Name prefix. This is used as a "friendly name" prefix when Terraform generates a
    random, unique name.

    Note: This conflicts with 'var.name'.
  EOT
  nullable    = true
  default     = null
}

variable "policy_arns" {
  type        = list(string)
  description = "(Optional) List of IAM Policy ARNs to attach to the GitHub Actions IAM Role."
  nullable    = false
  default     = []
}

variable "tags" {
  type        = map(string)
  description = <<-EOT
    (Optional) Key-value map of resource tags to be applied to all taggable resources within this module.

    If also configured with 'provider.default_tags' in the root module, tags with matching keys here will overwrite
    those defined at the provider-level.
  EOT
  default     = {}
  nullable    = false
}
