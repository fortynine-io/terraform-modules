output "arn" {
  description = "Kubernetes ServiceAccount IAM Role ARN."
  value       = aws_iam_role.irsa.arn
}

output "description" {
  description = "Kubernetes ServiceAccount IAM Role description."
  value       = aws_iam_role.irsa.description
}

output "name" {
  description = "Kubernetes ServiceAccount IAM Role name."
  value       = aws_iam_role.irsa.name
}
