variable "description" {
  type        = string
  description = <<-EOT
    (Required) IAM Role description.

    NOTE: IAM Roles created by this module will always have the following description format:
      "EKS IRSA: [eks_cluster.name] / [var.description]"
  EOT
  nullable    = false
}

variable "eks_cluster" {
  type = object({
    name = string
    oidc = object({
      arn = string
      url = string
    })
  })
  description = <<-EOT
    (Required) Host EKS Cluster details.

    Attributes:
      - name: (Required) EKS Cluster name.
      - oidc: EKS Cluster IAM OIDC provider configuration.
        - arn: (Required) IAM OIDC provider ARN.
        - url: (Required) IAM OIDC provider URL.
  EOT
  nullable    = false
}

variable "name_slug" {
  type        = string
  description = <<-EOT
    (Required) Name "slug" used in generating the IAM Role name.

    Notes:
      - EKS IRSA IAM Role names are given the following format: "eks-irsa-{name-slug}-{terraform-suffix}".
      - "-{terraform-suffix}" is 26 characters of entropy in the form of a timestamp added by Terraform to the end of
        each Role name.
      - Because a 37-character chunk of the the 64-character IAM Role name limit is already accounted for by the
        prefix/suffix components, [name_slug] cannot exceed 27 characters.

  EOT
  nullable    = false

  validation {
    condition     = length(var.name_slug) <= 27
    error_message = "[name_slug] must be 27 characters or less."
  }
}

variable "trust_policy_subjects" {
  type = object({
    exact_match = optional(list(string))
    like_match  = optional(list(string))
  })
  description = <<-EOT
    (Required) IAM Role trust policy OIDC subjects.

    Attributes:
      - exact_match: (Optional) List of fully-qualified Kubernetes Group or ServiceAccount resource names to assume the
        IAM Role for which the trust policy provides exact-matching via "StringEquals" condition.
      - like_match: (Optional) List of fully-qualified Kubernetes Group or ServiceAccount resource names (wildcards "*"
        permitted) to assume the IAM Role for which the trust policy provides like-matching via "StringLike" condition.
  EOT
  nullable    = false

  validation {
    condition     = length(coalesce(var.trust_policy_subjects.exact_match, [])) > 0 || length(coalesce(var.trust_policy_subjects.like_match, [])) > 0
    error_message = <<-EOT
      Either [trust_policy_subjects.exact_match] or [trust_policy_subjects.like_match] must be provided.
    EOT
  }
}


variable "path" {
  type        = string
  description = <<-EOT
    (Optional) IAM Role URI path.
  EOT
  nullable    = false
  default     = "/"
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
