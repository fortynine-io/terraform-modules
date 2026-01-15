output "arn" {
  description = "GitHub Actions IAM Role ARN."
  value       = aws_iam_role.github_actions.arn
}

output "name" {
  description = "GitHub Actions IAM Role name."
  value       = aws_iam_role.github_actions.name
}
