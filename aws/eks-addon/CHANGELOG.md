# `aws/eks-addon` Changelog

_The following sections summarize the changes made throughout this project and include the semantic version numbers and_
_approximate date each of the changes were made._

## 0.1.1 [04/30/2026]

* Fixes an issue handling `null` IRSA configuration defaults when add-on IRSA configuration is not required.
* Fixes improper `module.irsa` IAM Role name reference for policy attachment.

## 0.1.0 [03/13/2026]

* Initial module implementation.
  * Supports the creation of all EKS-managed add-ons without IRSA requirements.
  * Supports limited creation of EKS-managed add-ons with IRSA requirements: `amazon-cloudwatch-observability`,
    `aws-ebs-csi-driver`, `aws-efs-csi-driver` and `vpc-cni`.
