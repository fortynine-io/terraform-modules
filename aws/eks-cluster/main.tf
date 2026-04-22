data "aws_region" "current" {}

locals {
  module_version = trimspace(file("${path.module}/VERSION"))
  templates_path = "${path.module}/templates"

  default_tags = merge(var.tags, {
    "ops:terraform-module" = "github.com/fortynine-io/terraform-modules/aws/eks-cluster:${local.module_version}"
  })

  auto_mode         = var.auto_mode ? ["true"] : []
  iam_resource_path = "/eks/"
  aws_region        = data.aws_region.current.name
}
