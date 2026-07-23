locals {
  default_bucket_name = "${local.aws_account_id}.${local.aws_region}.s3-access-logs"
  bucket_name         = (var.name == "" || var.name == null) ? local.default_bucket_name : var.name
}

resource "aws_s3_bucket" "access_logs" {
  # checkov:skip=CKV_AWS_21:   (Bucket Versioning)                Unnecessary for S3 access logs...
  # checkov:skip=CKV_AWS_144:  (Cross-Region Replication)         Unnecessary for S3 access logs...
  # checkov:skip=CKV_AWS_145:  (Use Customer-managed KMS Keys)    S3 access logging does not support KMS encryption...
  # checkov:skip=CKV2_AWS_62:  (Bucket event Notifications)       Unnecessary for S3 access logs...
  bucket = local.bucket_name
}

data "aws_iam_policy_document" "access_logs" {
  statement {
    sid       = "CurrentAccountS3LoggingServiceAccess"
    effect    = "Allow"
    actions   = ["s3:PutObject"]
    resources = ["${aws_s3_bucket.access_logs.arn}/*"]

    principals {
      identifiers = ["logging.s3.amazonaws.com"]
      type        = "Service"
    }

    condition {
      test     = "ArnLike"
      variable = "aws:SourceArn"
      values   = var.source_arn_authorizations
    }

    condition {
      test     = "StringEquals"
      variable = "aws:SourceAccount"
      values   = [local.aws_account_id]
    }
  }
}

resource "aws_s3_bucket_policy" "access_logs" {
  bucket = aws_s3_bucket.access_logs.bucket
  policy = data.aws_iam_policy_document.access_logs.json
}

resource "aws_s3_bucket_public_access_block" "access_logs" {
  bucket = aws_s3_bucket.access_logs.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_server_side_encryption_configuration" "access_logs" {
  bucket = aws_s3_bucket.access_logs.id

  rule {
    blocked_encryption_types = ["SSE-C"]
    bucket_key_enabled       = false

    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_lifecycle_configuration" "access_logs" {
  bucket = aws_s3_bucket.access_logs.id

  rule {
    id     = "TransitionToCheaperTier"
    status = "Enabled"

    transition {
      days          = 7
      storage_class = var.log_retention_storage_class
    }
  }

  rule {
    id     = "ExpireAccessLogs"
    status = "Enabled"

    expiration {
      days = var.log_retention_days
    }
  }

  rule {
    id     = "AbortIncompleteMultipartUploads"
    status = "Enabled"

    abort_incomplete_multipart_upload {
      days_after_initiation = 1
    }
  }
}
