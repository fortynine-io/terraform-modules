# see: https://docs.aws.amazon.com/eks/latest/userguide/fargate-logging.html

# This policy differs from the official EKS Fargate logging documentation by disallowing the creation of a new Log
# Group. This enforces Terraform control over the Fargate Log Group creation...
resource "aws_iam_policy" "cloudwatch_fargate" {
  for_each = local.fargate_enabled_idx

  name_prefix = "${var.name}-cloudwatch-fargate-"
  description = "Cloudwatch privileges for EKS Fargate: [${var.name}]"
  path        = local.iam_resource_path

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "FargateCloudWatchLogging"
        Effect = "Allow"
        Action = [
          "logs:CreateLogStream",
          "logs:DescribeLogStreams",
          "logs:PutLogEvents",
          "logs:PutRetentionPolicy"
        ]
        Resource = [
          aws_cloudwatch_log_group.fargate["true"].arn,
          "${aws_cloudwatch_log_group.fargate["true"].arn}:*"
        ]
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "cloudwatch_fargate" {
  for_each = local.fargate_enabled_idx

  policy_arn = aws_iam_policy.cloudwatch_fargate["true"].arn
  role       = aws_iam_role.fargate_profile["true"].name
}
