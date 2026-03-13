# `aws/eks-irsa` Changelog

_The following sections summarize the changes made throughout this project and include the semantic version numbers and_
_approximate date each of the changes were made._

## 0.1.0 [03/12/2026]

* Removes `iam_role_` prefix from all output variables.
  * `output.arn`
  * `output.description`
  * `output.name`

## 0.0.1 [03/12/2026]

* Initial module implementation.
  * Creates an IAM Role for Kubernetes ServiceAccount resources
  * IAM Policy attachments must be performed via the calling module.
  * Introduces `var.iam_trust_policy_subjects` to configure which Kubernetes resources can assume (via OIDC provider)
    the IAM Role.
