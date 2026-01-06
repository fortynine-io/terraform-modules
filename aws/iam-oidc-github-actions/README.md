# `aws/iam-oidc-github-actions`

Terraform Module for provisioning an IAM OIDC identity provider for GitHub Actions workflows allowing for the seamless,
federated authentication of GitHub Actions workflows without having to provide long-lived AWS IAM `access_key_id` and
`secret_access_key` credentials.

## Design Notes

* This module can only be installed _once per AWS account_.
* The output(s) of this module can be used as inputs for the `aws/iam-role-github-actions` module.

## References

* [AWS Docs: Creating OpenID Connect (OIDC) Identity Providers][create-oidc-idp]
* [AWS Docs: Creating a Role for Web Identity or OIDC Federation][create-role-for-oidc-identity]
* [GitHub Docs: Configuring OpenID Connect in AWS][configuring-oidc-in-aws]

## Example Usage

_A complete example can be found in the [aws/iam-oidc-github-actions/example](/example) directory._

```hcl
module "example" {
  source = "git::https://github.com/fortynine-io/terraform-modules.git//aws/iam-oidc-github-actions?ref=aws/iam-oidc-github-actions/v0.1.0"

  tags = { "example-key" = "example-value" }
}
```

### AWS AuthN for GitHub Actions via IAM OIDC Provider

```yaml
- name: Authenticate via AWS IAM OIDC Provider
  uses: aws-actions/configure-aws-credentials@v5
  with:
    aws-region: ${{ env.AWS_REGION }}
    role-session-name: ${{ github.repository }}
    role-to-assume: arn:aws:iam::012345678910:role/github-actions/my-deploy-role
```

## Provider Requirements

_All provider requirements can be found in [aws/iam-oidc-github-actions/versions.tf](versions.tf)._

## Changelog

_A complete Changelog history can be found in [aws/iam-oidc-github-actions/CHANGELOG.md](CHANGELOG.md)._

## Input Variables

_All variable details can be found in [aws/iam-oidc-github-actions/variables.tf](variables.tf)._

| Variable Name | Description                                                                                           |
|---------------|-------------------------------------------------------------------------------------------------------|
| `tags`        | (Optional) Key-value map of resource tags to be applied to all taggable resources within this module. |

## Outputs

_All output details can be found in [aws/iam-oidc-github-actions/outputs.tf](outputs.tf)._

| Variable Name           | Description                           |
|-------------------------|---------------------------------------|
| `iam_oidc_provider_arn` | GitHub Actions IAM OIDC Provider ARN. |

[create-oidc-idp]: https://docs.aws.amazon.com/IAM/latest/UserGuide/id_roles_providers_create_oidc.html
[create-role-for-oidc-identity]: https://docs.aws.amazon.com/IAM/latest/UserGuide/id_roles_create_for-idp_oidc.html
[configuring-oidc-in-aws]: https://docs.github.com/en/actions/deployment/security-hardening-your-deployments/configuring-openid-connect-in-amazon-web-services
