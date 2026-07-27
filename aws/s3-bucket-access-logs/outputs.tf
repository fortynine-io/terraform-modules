output "arn" {
  description = "S3 Access Logs Bucket ARN."
  value       = aws_s3_bucket.access_logs.arn
}

output "id" {
  description = "S3 Access Logs Bucket name."
  value       = aws_s3_bucket.access_logs.id
}

output "region" {
  description = "S3 Access Logs Bucket AWS Region."
  value       = aws_s3_bucket.access_logs.bucket_region
}
