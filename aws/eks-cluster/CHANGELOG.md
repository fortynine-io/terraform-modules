# `aws/eks-cluster` Changelog

_The following sections summarize the changes made throughout this project and include the semantic version numbers and_
_approximate date each of the changes were made._

## 0.0.2 [07/01/2026]

* Removes `aws_eks_fargate_profile.default` resource that was automatically created if `var.fargate = true` forcing all
  Fargate Profiles to be explicitly defined and configured by the caller.

## 0.0.1 [04/22/2026]

* Initial module implementation.
  * Supports the creation of EKS Cluster (Auto-Mode and Fargate Profiles) and associated resources.
