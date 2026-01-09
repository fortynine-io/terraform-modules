output "iam_oidc_provider_arn" {
  description = "GitHub Actions IAM OIDC Provider ARN."
  value       = aws_iam_openid_connect_provider.default.arn
}
