resource "aws_cloudwatch_log_group" "cluster" {
  name = "/aws/eks/${var.name}/cluster"

  kms_key_id        = var.kms_key_id
  retention_in_days = var.log_retention_in_days

  tags = local.default_tags
}

resource "aws_cloudwatch_log_group" "fargate" {
  for_each = local.fargate_enabled_idx

  name = "/aws/eks/${var.name}/fargate"

  kms_key_id        = var.kms_key_id
  retention_in_days = var.log_retention_in_days

  tags = local.default_tags
}

# Log Groups for EKS Container Insights
# TODO: Make these optional (via bool var) or reboot terraform-aws-eks-cloudwatch...?
# Container Insights is enabled only if the "amazon-cloudwatch-observability" add-on is installed or if the Cloudwatch
# Agent is installed/configured on the EC2 instance nodes via Node Group Launch template (which is outside the scope of
# this module)...

resource "aws_cloudwatch_log_group" "insights_application" {
  name = "/aws/containerinsights/${var.name}/application"

  kms_key_id        = var.kms_key_id
  retention_in_days = var.log_retention_in_days

  tags = local.default_tags
}

resource "aws_cloudwatch_log_group" "insights_dataplane" {
  name = "/aws/containerinsights/${var.name}/dataplane"

  kms_key_id        = var.kms_key_id
  retention_in_days = var.log_retention_in_days

  tags = local.default_tags
}

resource "aws_cloudwatch_log_group" "insights_host" {
  name = "/aws/containerinsights/${var.name}/host"

  kms_key_id        = var.kms_key_id
  retention_in_days = var.log_retention_in_days

  tags = local.default_tags
}

resource "aws_cloudwatch_log_group" "insights_performance" {
  name = "/aws/containerinsights/${var.name}/performance"

  kms_key_id        = var.kms_key_id
  retention_in_days = var.log_retention_in_days

  tags = local.default_tags
}

