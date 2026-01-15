locals {
  description               = "GitHub Actions Role: ${var.description}"
  repo_authorization_scopes = compact(distinct(var.repo_authorization_scopes))
}


data "aws_iam_policy_document" "trust_policy" {
  statement {
    sid     = "TrustPolicy"
    effect  = "Allow"
    actions = ["sts:AssumeRoleWithWebIdentity"]

    principals {
      type        = "Federated"
      identifiers = [var.iam_oidc_provider_arn]
    }

    condition {
      test     = "StringEquals"
      variable = "token.actions.githubusercontent.com:aud"
      values   = ["sts.amazonaws.com"]
    }

    condition {
      test     = "StringLike"
      variable = "token.actions.githubusercontent.com:sub"
      values   = local.repo_authorization_scopes
    }
  }
}

resource "aws_iam_role" "github_actions" {
  name        = var.name
  name_prefix = var.name_prefix
  path        = var.path
  description = local.description

  assume_role_policy = data.aws_iam_policy_document.trust_policy.json

  # Enabling this in case policy attachments are made outside of this module using the 'aws_iam_policy_attachment'
  # resource instead of the 'aws_iam_role_policy_attachment' resource...
  force_detach_policies = true

  tags = local.default_tags
}
