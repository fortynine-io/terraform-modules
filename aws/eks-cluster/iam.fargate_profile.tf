locals {
  fargate_enabled     = var.fargate ? true : false
  fargate_enabled_idx = toset(local.fargate_enabled ? ["true"] : [])

  fargate_role_policy_attachments = local.fargate_enabled ? [
    "arn:aws:iam::aws:policy/AmazonEKSFargatePodExecutionRolePolicy"
  ] : []
  fargate_profiles = local.fargate_enabled ? var.fargate_profiles : {}
}


data "aws_iam_policy_document" "fargate_profile_trust_policy" {
  statement {
    sid    = "FargateProfileTrustPolicy"
    effect = "Allow"

    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["eks-fargate-pods.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "fargate_profile" {
  for_each = local.fargate_enabled_idx

  name        = "${var.name}-fargate-profile"
  path        = local.iam_resource_path
  description = "EKS Fargate Profile Role: [${var.name}]"

  assume_role_policy    = data.aws_iam_policy_document.fargate_profile_trust_policy.json
  force_detach_policies = true
}

resource "aws_iam_role_policy_attachment" "fargate_profile" {
  for_each = toset(local.fargate_role_policy_attachments)

  policy_arn = each.value
  role       = aws_iam_role.fargate_profile["true"].name
}

resource "aws_eks_fargate_profile" "custom" {
  for_each = local.fargate_profiles

  cluster_name           = aws_eks_cluster.default.name
  fargate_profile_name   = each.key
  pod_execution_role_arn = aws_iam_role.fargate_profile["true"].arn
  subnet_ids             = var.vpc_config.subnet_ids

  selector {
    namespace = each.value.namespace
    labels    = each.value.labels
  }
}
