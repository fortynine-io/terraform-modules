# `aws/iam-oidc-github-actions` Changelog

_The following sections summarize the changes made throughout this project and include the semantic version numbers and_
_approximate date each of the changes were made._

## 0.1.1 [01/14/2026]

* Adds `aws_iam_openid_connect_provider.thumbprint_list` because AWS auto-assigns this if not present. Since
  `lifecycle.ignore_changes` is not configured for this field, the resource will show a diff in the Terraform plan for
  every invocation.

## 0.1.0 [01/05/2026]

* Initial Module implementation.
  * Creates a `aws_iam_openid_connect_provider` resource to support OIDC federated identity authentication for GitHub
    Actions workflows.
