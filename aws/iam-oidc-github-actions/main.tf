locals {
  # aws_region     = data.aws_region.current.name
  # aws_account_id = data.aws_caller_identity.current.account_id
  module_version = trimspace(file("${path.module}/VERSION"))
  # templates_path = "${path.module}/templates"

  default_tags = merge(var.tags, {
    "ops/terraform-module" = "knox-networks/terraform-aws-github-oidc:${local.module_version}"
  })
}


# data "aws_region" "current" {}
# data "aws_caller_identity" "current" {}
