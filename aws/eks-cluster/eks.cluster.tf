locals {
  log_types               = compact(distinct(var.log_types))
  vpc_public_access_cidrs = compact(distinct(var.vpc_config.public_access_cidrs))
  vpc_security_group_ids  = compact(distinct(concat([aws_security_group.cluster.id], var.vpc_config.security_group_ids)))
}


resource "aws_eks_cluster" "default" {
  name    = var.name
  version = var.cluster_version

  bootstrap_self_managed_addons = !var.auto_mode
  enabled_cluster_log_types     = local.log_types
  role_arn                      = aws_iam_role.cluster.arn
  tags                          = local.default_tags

  access_config {
    authentication_mode                         = "API"
    bootstrap_cluster_creator_admin_permissions = false
  }

  dynamic "compute_config" {
    for_each = toset(local.auto_mode)

    content {
      enabled       = true
      node_pools    = ["general-purpose"]
      node_role_arn = aws_iam_role.auto_mode_node["true"].arn
    }
  }

  encryption_config {
    resources = ["secrets"]

    provider {
      key_arn = var.kms_key_id
    }
  }

  kubernetes_network_config {
    ip_family         = "ipv4"
    service_ipv4_cidr = "172.20.0.0/16"

    dynamic "elastic_load_balancing" {
      for_each = toset(local.auto_mode)

      content {
        enabled = true
      }
    }
  }

  dynamic "storage_config" {
    for_each = toset(local.auto_mode)

    content {
      block_storage {
        enabled = true
      }
    }
  }

  timeouts {
    create = var.timeouts.create
    delete = var.timeouts.delete
    update = var.timeouts.update
  }

  upgrade_policy {
    support_type = var.upgrade_support_type
  }

  vpc_config {
    security_group_ids      = local.vpc_security_group_ids
    subnet_ids              = var.vpc_config.subnet_ids
    endpoint_private_access = var.vpc_config.endpoint_private_access
    endpoint_public_access  = var.vpc_config.endpoint_public_access
    public_access_cidrs     = local.vpc_public_access_cidrs
  }

  depends_on = [
    aws_cloudwatch_log_group.cluster,
    aws_iam_role_policy_attachment.cluster,
    aws_security_group.cluster
  ]
}
