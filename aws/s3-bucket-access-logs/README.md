# `aws/s3-bucket-access-logs`

Terraform Module for provisioning an S3 Bucket suitable for maintaining S3 server access logs.

## Design Notes

* By default, the access log bucket maintains all log files for an initial 7-day period in S3's `Standard` access tier.
  After 7 days, files automatically transfer to the `Glacier Instant Retrieval` access tier -- the cheapest tier with
  (millisecond) immediate access enabling inspection via tools such as Amazon Athena without requiring transition to a
  faster access tier first. Callers can override the transition storage class by modifying
  `var.log_retention_storage_class`.
* By default, the access log bucket maintains all log files for `365` days to meet most compliance scenarios. However,
  callers can override this setting by modifying `var.log_retention_days`.

## References

[AWS Docs: Enabling S3 Server Access Logging](https://docs.aws.amazon.com/AmazonS3/latest/userguide/enable-server-access-logging.html)

## Example Usage

_A complete example can be found in the [aws/s3-bucket-access-logs/example](/example) directory._

```hcl
module "s3_bucket_access_logs" {
  source = "git::https://github.com/fortynine-io/terraform-modules.git//aws/s3-bucket-access-logs?ref=aws/eks-addon/v0.1.1"

  # Implement required module configuration here...

  tags = local.default_tags
}
```

## Changelog

_A complete Changelog history can be found in [aws/s3-bucket-access-logs/CHANGELOG.md](CHANGELOG.md)._

## Provider Requirements

_All provider requirements can be found in [aws/s3-bucket-access-logs/versions.tf](versions.tf)._

## Input Variables

_All variable details can be found in [aws/s3-bucket-access-logs/variables.tf](variables.tf)._

| Variable Name | Description                                                                                           |
|---------------|-------------------------------------------------------------------------------------------------------|
| `tags`        | (Optional) Key-value map of resource tags to be applied to all taggable resources within this module. |

## Outputs

_All output details can be found in [aws/s3-bucket-access-logs/outputs.tf](outputs.tf)._

| Variable Name       | Description       |
| -------------       | -----------       |
