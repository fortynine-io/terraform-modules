output "iam_role_arn" {
  description = "Kubernetes ServiceAccount IAM Role ARN."
  value       = aws_iam_role.irsa.arn
}

output "iam_role_description" {
  description = "Kubernetes ServiceAccount IAM Role description."
  value       = aws_iam_role.irsa.description
}

output "iam_role_name" {
  description = "Kubernetes ServiceAccount IAM Role name."
  value       = aws_iam_role.irsa.name
}
