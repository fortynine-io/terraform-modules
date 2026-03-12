locals {
  iam_resource_desc = "EKS IRSA: ${var.eks_cluster.name} / ${var.description}"

  has_exact_match_subjects = (length(coalesce(var.trust_policy_subjects.exact_match, [])) > 0)
  has_like_match_subjects  = (length(coalesce(var.trust_policy_subjects.like_match, [])) > 0)
  exact_match_subjects     = local.has_exact_match_subjects ? [true] : []
  like_match_subjects      = (local.has_like_match_subjects && !local.has_exact_match_subjects) ? [true] : []
}


data "aws_iam_policy_document" "trust_policy" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRoleWithWebIdentity"]

    principals {
      type        = "Federated"
      identifiers = [var.eks_cluster.oidc.arn]
    }

    condition {
      test     = "StringEquals"
      variable = "${var.eks_cluster.oidc.url}:aud"
      values   = ["sts.amazonaws.com"]
    }

    dynamic "condition" {
      for_each = local.exact_match_subjects
      content {
        test     = "StringEquals"
        variable = "${var.eks_cluster.oidc.url}:sub"
        values   = var.trust_policy_subjects.exact_match
      }
    }

    dynamic "condition" {
      for_each = local.like_match_subjects
      content {
        test     = "StringLike"
        variable = "${var.eks_cluster.oidc.url}:sub"
        values   = var.trust_policy_subjects.like_match
      }
    }
  }
}

resource "aws_iam_role" "irsa" {
  name_prefix = "eks-irsa-${var.name_slug}-"
  description = local.iam_resource_desc

  path               = var.path
  assume_role_policy = data.aws_iam_policy_document.trust_policy.json

  tags = local.default_tags

  lifecycle {
    create_before_destroy = true
  }
}
