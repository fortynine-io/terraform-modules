variable "log_retention_days" {
  type        = number
  description = <<-EOT
    (Optional) Number of days for which to retain S3 access log files.
  EOT
  nullable    = true
  default     = 365
}

variable "log_retention_storage_class" {
  type        = string
  description = <<-EOT
    (Optional) S3 Storage Class to transition log files to after 7 days.
  EOT
  nullable    = false
  default     = "GLACIER_IR"
}

variable "name" {
  type        = string
  description = <<-EOT
    (Optional) S3 Bucket name.

    Note: If omitted, a default bucket name will be generated with the following format:
      <aws_account_id>.<aws_region>.s3-access-logs
  EOT
  nullable    = true
  default     = null
}

variable "source_arn_authorizations" {
  type        = list(string)
  description = <<-EOT
    (Optional) List of S3 Bucket ARNs to authorize s3:PutObject access to the access logs bucket.

    Note: This module disallows cross-account access to the logs bucket. Any authorized S3 Bucket ARN must exist in the
      same AWS account as the access logs bucket. By default, all S3 Buckets within the same AWS account are permitted
      to write access logs.
  EOT
  nullable    = false
  default     = ["arn:aws:s3:::*"]
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
