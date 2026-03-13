# `aws/iam-role-github-actions`

Terraform Module for provisioning an IAM Role to be assumed by GitHub Actions workflows.

## Design Notes

* This module does not manage policy attachments for the IAM Role. Those must be maintained by the calling root module.
* This module is designed to work in conjunction with the `aws/iam-oidc-github-actions` module as
  `var.iam_oidc_provider_arn` requires the ARN of an IAM OIDC Provider (configured to trust GitHub Actions) to grant
  `sts:AssumeRoleWithWebIdentity` privileges.
* The temporary credentials assumed by the federated OIDC web identity (provided by the GitHub Actions workflow and
  trusted by the affiliated GitHub Actions IAM OIDC Provider), is a _much more secure option_ than maintaining
  long-lived AWS IAM User credentials (i.e.`AWS_ACCESS_KEY_ID` and `AWS_SECRET_ACCESS_KEY`) via GitHub Actions secrets.

## References

* [GitHub Docs: Configuring OpenID Connect in Amazon Web Services][gha-config-oidc-in-aws]
* [GitHub Docs: Configuring the Role and Trust Policy ("Authorization Scope")][gha-config-oidc-in-aws-trust-policy]

## Example Usage

_A complete example can be found in the [aws/iam-oidc-github-actions/example](/example) directory._

```hcl
module "example" {
  source = "git::https://github.com/fortynine-io/terraform-modules.git//aws/iam-oidc-github-actions?ref=aws/iam-role-github-actions/v0.1.0"

  name        = "github-actions-terraform"
  description = "grants deployment permissions for all AWS terraform root module repos"

  iam_oidc_provider_arn     = module.github_oidc.provider_arn
  repo_authorization_scopes = ["repo:acme-org/tfmod.aws.*"]

  tags = { "example-key" = "example-value" }
}
```

### GitHub Actions Authorization Scopes

The federated identity request for GitHub Actions to assume an AWS IAM Role presents an OIDC `sub` (subject) field in
the following formats:

* Branch Reference: `repo:<github-org>/<repo-name>:ref:refs/heads/<repo-branch>`.
* Environment Reference: `repo:<github-org>/<repo-name>:environment:<environment-name>`

`var.repo_authorization_scopes` accepts a list of OIDC subject values and allows callers the ability to restrict assume
role access all the way down to the individual repo branch if necessary. More often however, assume role access will not
require that particular level granularity. The following examples demonstrate various configuration approaches
for `var.repo_authorization_scope` depending on your use case.

```hcl
# Allow all repos for a specific organization...
authorization_scopes = ["repo:gh-org/*"]

# Allow all branches within a individual repository...
authorization_scopes = ["repo:gh-org/gh-repo:*"]

# Allow all repos that begin with "terraform-aws-" (all terraform modules)...
authorization_scopes = ["repo:gh-org/terraform-aws-*"]

# Allow all repos that begin with "terraform-aws-" (all AWS terraform modules)... AND
# Allow all repos that begin with "tfmod.aws." (all AWS terraform root modules)...
authorization_scopes = [
  "repo:gh-org/terraform-aws-*",
  "repo:gh-org/tfmod.aws.*"
]

# Allow repo access one-by-one...
authorization_scopes = [
  "repo:gh-org/repo-1:*",
  "repo:gh-org/repo-2:*",
  "repo:gh-org/repo-3:*"
]
```

### AWS AuthN for GitHub Actions via IAM OIDC Provider

```yaml
- name: Authenticate via AWS IAM OIDC Provider
  uses: aws-actions/configure-aws-credentials@v5
  with:
    aws-region: ${{ env.AWS_REGION }}
    role-session-name: ${{ github.repository }}
    role-to-assume: arn:aws:iam::012345678910:role/github-actions-deployment-role
```

## Provider Requirements

_All provider requirements can be found in [aws/iam-oidc-github-actions/versions.tf](versions.tf)._

## Changelog

_A complete Changelog history can be found in [aws/iam-oidc-github-actions/CHANGELOG.md](CHANGELOG.md)._

## Input Variables

_All variable details can be found in [aws/iam-oidc-github-actions/variables.tf](variables.tf)._

| Variable Name               | Description                                                                                             |
|-----------------------------|---------------------------------------------------------------------------------------------------------|
| `description`               | (Required) GitHub Actions IAM Role description.                                                         |
| `iam_oidc_provider_arn`     | (Required) GitHub Actions IAM OIDC Provider ARN.                                                        |
| `repo_authorization_scopes` | (Required) List of GitHub authorization scopes permitting access to assume the GitHub Actions IAM Role. |
| `name`                      | (Optional) GitHub Actions IAM Role name.                                                                |
| `name_prefix`               | (Optional) GitHub Actions IAM Role Name prefix.                                                         |
| `path`                      | (Optional) GitHub Actions IAM Role URI path.                                                            |
| `tags`                      | (Optional) Key-value map of resource tags to be applied to all taggable resources within this module.   |

## Outputs

_All output details can be found in [aws/iam-oidc-github-actions/outputs.tf](outputs.tf)._

| Variable Name | Description                          |
|---------------|--------------------------------------|
| `arn`         | GitHub Actions IAM Role arn.         |
| `description` | GitHub Actions IAM Role description. |
| `name`        | GitHub Actions IAM Role name.        |

[gha-config-oidc-in-aws]: https://docs.github.com/en/actions/how-tos/secure-your-work/security-harden-deployments/oidc-in-aws
[gha-config-oidc-in-aws-trust-policy]: https://docs.github.com/en/actions/how-tos/secure-your-work/security-harden-deployments/oidc-in-aws#configuring-the-role-and-trust-policy
