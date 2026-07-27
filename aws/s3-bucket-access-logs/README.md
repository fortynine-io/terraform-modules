# `aws/s3-bucket-access-logs`

Terraform Module for provisioning an S3 Bucket for the purpose of maintaining S3 server access logs.

## Design Notes

* This module does not provide S3 object lifecycle rules to transition files to a cheaper storage tier. S3 access
  logs are usually well under the `128Kb` default minimum size for files to transition storage classes and would
  generally accrue more in transition costs than would be saved by a storage tier transition.
* By default, the access log bucket maintains all log files for `365` days to meet most compliance scenarios. However,
  callers can override this setting by modifying `var.log_retention_days`.
* S3 buckets will have the following name format if `var.name` is not provided:
  `<aws-account-id>.<aws-region>.s3-access-logs`

## References

[AWS Docs: Enabling S3 Server Access Logging](https://docs.aws.amazon.com/AmazonS3/latest/userguide/enable-server-access-logging.html)
[AWS Docs: S3 Constraints / Considerations for Object Transitions](https://docs.aws.amazon.com/AmazonS3/latest/userguide/lifecycle-transition-general-considerations.html#lifecycle-configuration-constraints)

## Example Usage

_A complete example can be found in the [aws/s3-bucket-access-logs/example](/example) directory._

```hcl
module "s3_bucket_access_logs" {
  source = "git::https://github.com/fortynine-io/terraform-modules.git//aws/s3-bucket-access-logs?ref=aws/s3-bucket-access-logs/v0.1.0"

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

| Variable Name               | Description                                                                                           |
|-----------------------------|-------------------------------------------------------------------------------------------------------|
| `log_retention_days`        | (Optional) Number of days for which to retain S3 access log files.                                    |
| `name`                      | (Optional) S3 Bucket name.                                                                            |
| `source_arn_authorizations` | (Optional) List of S3 Bucket ARNs to authorize s3:PutObject access to the access logs bucket.         |
| `tags`                      | (Optional) Key-value map of resource tags to be applied to all taggable resources within this module. |

## Outputs

_All output details can be found in [aws/s3-bucket-access-logs/outputs.tf](outputs.tf)._

| Variable Name | Description                       |
|---------------|-----------------------------------|
| `arn`         | S3 Access Logs Bucket ARN.        |
| `id`          | S3 Access Logs Bucket name.       |
| `region`      | S3 Access Logs Bucket AWS Region. |
