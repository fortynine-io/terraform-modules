output "arn" {
  description = "GitHub Actions IAM Role ARN."
  value       = aws_iam_role.github_actions.arn
}

output "description" {
  description = "GitHub Actions IAM Role description."
  value       = aws_iam_role.github_actions.description
}

output "name" {
  description = "GitHub Actions IAM Role name."
  value       = aws_iam_role.github_actions.name
}
