resource "aws_eks_addon" "addon" {
  addon_name    = var.name
  addon_version = var.addon_version
  cluster_name  = var.cluster_name

  configuration_values = var.configuration_values

  preserve                    = false
  resolve_conflicts_on_create = "OVERWRITE"
  resolve_conflicts_on_update = "OVERWRITE"
  service_account_role_arn    = try(module.irsa["true"].arn, null)

  timeouts {
    create = var.timeouts.create
    update = var.timeouts.update
    delete = var.timeouts.delete
  }

  tags = local.default_tags
}
