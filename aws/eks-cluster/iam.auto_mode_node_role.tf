locals {
  auto_mode_node_role_name = "${var.name}-auto-mode-node"

  auto_mode_node_default_role_policies = [
    "arn:aws:iam::aws:policy/AmazonEKSWorkerNodeMinimalPolicy",
    "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryPullOnly"
  ]

  auto_mode_node_role_policies = var.auto_mode ? local.auto_mode_node_default_role_policies : []
}

data "aws_iam_policy_document" "auto_mode_node_trust_policy" {
  for_each = toset(local.auto_mode)

  statement {
    sid     = "EKSAutoModeNodeTrustPolicy"
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "auto_mode_node" {
  for_each = toset(local.auto_mode)

  name        = local.auto_mode_node_role_name
  description = "EKS Auto Mode Node Role: [${var.name}]"

  assume_role_policy = data.aws_iam_policy_document.auto_mode_node_trust_policy["true"].json
}

resource "aws_iam_role_policy_attachment" "auto_mode_node" {
  for_each = toset(local.auto_mode_node_role_policies)

  policy_arn = each.value
  role       = aws_iam_role.auto_mode_node["true"].name
}
