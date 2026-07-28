data "aws_region" "current" {}
data "aws_caller_identity" "current" {}

locals {
  aws_account_id = data.aws_caller_identity.current.account_id
  aws_region     = data.aws_region.current.region
  module_version = trimspace(file("${path.module}/VERSION"))
  # templates_path = "${path.module}/templates"

  default_tags = merge(var.tags, {
    "ops/terraform-module" = "github.com/fortynine-io/terraform-modules/aws/s3-bucket-access-logs:${local.module_version}"
  })
}
