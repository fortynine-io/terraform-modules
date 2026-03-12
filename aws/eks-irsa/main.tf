locals {
  module_version = trimspace(file("${path.module}/VERSION"))

  default_tags = merge(var.tags, {
    "ops/terraform-module" = "github.com/fortynine-io/terraform-modules/aws/eks-irsa:${local.module_version}"
  })
}
