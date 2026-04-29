output "auto_mode" {
  description = "Boolean indicating whether or not EKS Auto Mode is enabled."
  value       = var.auto_mode
}

output "auto_mode_node_role" {
  description = "EKS Auto Mode Node IAM Role details."
  value = var.auto_mode ? {
    arn         = aws_iam_role.auto_mode_node["true"].arn
    description = aws_iam_role.auto_mode_node["true"].description
    name        = aws_iam_role.auto_mode_node["true"].name
  } : null
}

output "cloudwatch" {
  description = "Amazon CloudWatch Log Group details."
  value = {
    "cluster" = {
      arn  = aws_cloudwatch_log_group.cluster.arn
      name = aws_cloudwatch_log_group.cluster.name
    }
    "fargate" = var.fargate ? {
      arn  = aws_cloudwatch_log_group.fargate["true"].arn
      name = aws_cloudwatch_log_group.fargate["true"].name
    } : null
    "container_insights_application" = {
      arn  = aws_cloudwatch_log_group.insights_application.arn
      name = aws_cloudwatch_log_group.insights_application.name
    }
    "container_insights_dataplane" = {
      arn  = aws_cloudwatch_log_group.insights_dataplane.arn
      name = aws_cloudwatch_log_group.insights_dataplane.name
    }
    "container_insights_host" = {
      arn  = aws_cloudwatch_log_group.insights_host.arn
      name = aws_cloudwatch_log_group.insights_host.name
    }
    "container_insights_performance" = {
      arn  = aws_cloudwatch_log_group.insights_performance.arn
      name = aws_cloudwatch_log_group.insights_performance.name
    }
  }
}

output "cluster_arn" {
  description = "EKS Cluster ARN."
  value       = aws_eks_cluster.default.arn
}

output "cluster_endpoint" {
  description = "EKS Cluster HTTPS endpoint."
  value       = aws_eks_cluster.default.endpoint
}

output "cluster_name" {
  description = "EKS Cluster name."
  value       = aws_eks_cluster.default.name
}

output "cluster_oidc" {
  description = "EKS Cluster OIDC Provider properties."
  value = {
    arn = aws_iam_openid_connect_provider.default.arn
    url = replace(aws_iam_openid_connect_provider.default.url, "https://", "")
  }
}

output "cluster_role" {
  description = "EKS Cluster IAM Role details."
  value = {
    arn         = aws_iam_role.cluster.arn
    description = aws_iam_role.cluster.description
    name        = aws_iam_role.cluster.name
  }
}

output "fargate_role" {
  description = "EKS Fargate Profile IAM Role details."
  value = var.fargate ? {
    arn         = aws_iam_role.fargate_profile["true"].arn
    description = aws_iam_role.fargate_profile["true"].description
    name        = aws_iam_role.fargate_profile["true"].name
  } : null
}

data "aws_security_group" "eks" {
  id = aws_eks_cluster.default.vpc_config[0].cluster_security_group_id

  depends_on = [aws_eks_cluster.default]
}

output "cluster_security_groups" {
  description = "Configuration map for EKS Cluster-related Security Groups."
  value = {
    eks = {
      id          = data.aws_security_group.eks.id
      description = data.aws_security_group.eks.description
      name        = data.aws_security_group.eks.name
    }
    cluster = {
      id          = aws_security_group.cluster.id
      description = aws_security_group.cluster.description
      name        = aws_security_group.cluster.name
    }
  }
}

output "cluster_version" {
  description = "EKS Cluster version."
  value       = aws_eks_cluster.default.version
}

output "k8s_auth" {
  description = "Configuration map for Kubernetes/Helm Terraform providers."
  sensitive   = true
  value = {
    host           = aws_eks_cluster.default.endpoint
    token          = data.aws_eks_cluster_auth.default.token
    ca_certificate = aws_eks_cluster.default.certificate_authority[0].data
  }
}
