locals {
  cluster_iam_role_name = "${var.name}-cluster-role"

  cluster_role_default_policies = [
    "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy",
    "arn:aws:iam::aws:policy/AmazonEKSVPCResourceController"
  ]

  cluster_role_auto_mode_policies = var.auto_mode ? [
    "arn:aws:iam::aws:policy/AmazonEKSComputePolicy",
    "arn:aws:iam::aws:policy/AmazonEKSBlockStoragePolicy",
    "arn:aws:iam::aws:policy/AmazonEKSLoadBalancingPolicy",
    "arn:aws:iam::aws:policy/AmazonEKSNetworkingPolicy"
  ] : []

  cluster_role_policies = compact(distinct(concat(local.cluster_role_default_policies, local.cluster_role_auto_mode_policies, var.role_policies)))
}


data "aws_iam_policy_document" "cluster_trust_policy" {
  statement {
    sid     = "EKSClusterTrustPolicy"
    actions = ["sts:AssumeRole", "sts:TagSession"]

    principals {
      type        = "Service"
      identifiers = ["eks.amazonaws.com"]
    }
  }
}

# see: https://docs.aws.amazon.com/eks/latest/userguide/cluster-iam-role.html
resource "aws_iam_role" "cluster" {
  name        = local.cluster_iam_role_name
  path        = local.iam_resource_path
  description = "EKS Cluster Role: [${var.name}]"

  assume_role_policy    = data.aws_iam_policy_document.cluster_trust_policy.json
  force_detach_policies = true

  tags = local.default_tags
}

resource "aws_iam_role_policy_attachment" "cluster" {
  for_each = toset(local.cluster_role_policies)

  role       = aws_iam_role.cluster.name
  policy_arn = each.value
}

resource "aws_iam_policy" "cloudwatch_cluster" {
  name_prefix = "${var.name}-cloudwatch-"
  description = "CloudWatch privileges for EKS Cluster: [${var.name}]"
  path        = local.iam_resource_path

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      # Cluster resources are still generating CloudWatch logs as the module resources are being destroyed which results
      # in the EKS Cluster recreating the Log Group (even after "terraform destroy"). This prohibits the EKS Cluster
      # from creating CloudWatch Log Groups outside of the Terraform context.
      {
        Sid    = "DenyCloudWatchLogGroupCreation"
        Effect = "Deny"
        Action = ["logs:CreateLogGroup"]
        Resource = [
          aws_cloudwatch_log_group.cluster.arn,
          aws_cloudwatch_log_group.insights_application.arn,
          aws_cloudwatch_log_group.insights_dataplane.arn,
          aws_cloudwatch_log_group.insights_host.arn,
          aws_cloudwatch_log_group.insights_performance.arn
        ]
      },
    ]
  })

  tags = local.default_tags
}

resource "aws_iam_role_policy_attachment" "cloudwatch_cluster" {
  policy_arn = aws_iam_policy.cloudwatch_cluster.arn
  role       = aws_iam_role.cluster.name
}

resource "aws_iam_policy" "encryption_cluster" {
  name_prefix = "${var.name}-encryption-"
  description = "KMS privileges for EKS Cluster: [${var.name}]"
  path        = local.iam_resource_path

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid = "KMSKeyAccessForEBSVolumeEncryption"
        Action = [
          "kms:Encrypt",
          "kms:Decrypt",
          "kms:ListGrants",
          "kms:DescribeKey"
        ]
        Effect   = "Allow"
        Resource = var.kms_key_id
      },
    ]
  })

  tags = local.default_tags
}

resource "aws_iam_role_policy_attachment" "encryption_cluster" {
  policy_arn = aws_iam_policy.encryption_cluster.arn
  role       = aws_iam_role.cluster.name
}
