# see: https://docs.aws.amazon.com/eks/latest/userguide/fargate-logging.html

locals {
  fargate_config_map_tpl = "${local.templates_path}/kubernetes/ConfigMap_fargate_logging.yaml.tpl"
  fargate_logging_params = {
    log_group_name = "/aws/eks/${var.name}/fargate"
    region         = local.aws_region
  }
}


resource "kubernetes_namespace_v1" "aws_observability" {
  for_each = local.fargate_enabled_idx

  metadata {
    name = "aws-observability"

    labels = {
      "kubernetes.io/metadata.name" = "aws-observability"
      "aws-observability"           = "enabled"
    }
  }
}

resource "kubernetes_manifest" "aws_observability_config_map" {
  for_each = local.fargate_enabled_idx

  manifest = yamldecode(templatefile(local.fargate_config_map_tpl, local.fargate_logging_params))

  depends_on = [
    kubernetes_namespace_v1.aws_observability
  ]
}

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
