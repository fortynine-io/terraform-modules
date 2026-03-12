# `aws/eks-irsa`

Terraform module for provisioning IAM Roles for Kubernetes ServiceAccount (IRSA) resources in EKS.

## Design Notes

* This module does not manage policy attachments for the IAM Role. Those must be maintained by the calling module.
* The `aws_iam_role.irsa` resource is created using the `name_prefix` attribute rather than `name`. With `name_prefix`,
  Terraform appends entropy in the form of a timestamp to create uniqueness in the resource name, thus allowing the
  following:
  * IAM resources can be created with `lifecycle.create_before_destroy = true` minimizing disruptions for any services
    that might actively be using the resources.
  * Additional EKS Clusters within the same AWS Account or additional "like" services within the same EKS Cluster (i.e.
    _within a different k8s namespace_) are able to create the same IRSA components.
* `var.iam_trust_policy_subjects` configures which EKS / Kubernetes `Group` or `ServiceAccount` resources will have
  access (via EKS OIDC provider) to assume the IAM Role created by this module.
  * `var.iam_trust_policy_subjects.exact_match` is preferred over `var.iam_trust_policy_subjects.like_match`
    as it provides the most explicit privilege assignment.
  * `var.iam_trust_policy_subjects.like_match` allows callers to craft a subject list using wildcard [`*`] characters.
    This is useful for scenarios where multiple service accounts (possibly in separate Kubernetes namespaces) need
    similar AWS access.
  * Either `var.iam_trust_policy_subjects.exact_match` or `var.iam_trust_policy_subjects.like_match` are required. If
    both values are provided, only `var.iam_trust_policy_subjects.exact_match` is used.

## Example Usage

_A complete example can be found in the [aws/eks-irsa/example](/example) directory._

```hcl
module "irsa" {
  source = "git::https://github.com/fortynine-io/terraform-modules.git//aws/eks-irsa?ref=aws/eks-irsa/v0.1.0"

  eks_cluster = {
    name = "your-eks-cluster-name"
    oidc = {
      arn = "arn:aws:iam::012345678910:oidc-provider/oidc.eks.us-east-1.amazonaws.com/id/ABCDEFABDCDFABCDEFABCDEFABCDEFAB"
      url = "oidc.eks.us-east-1.amazonaws.com/id/ABCDEFABDCDFABCDEFABCDEFABCDEFAB"
    }
  }

  iam_role_name_slug = "example"

  iam_trust_policy_subjects = {
    exact_match = ["system:serviceaccount:example-namespace:example-service]
  }

  tags = var.tags
}
```

## Provider Requirements

_All provider requirements can be found in [aws/eks-irsa/versions.tf](versions.tf)._

## Changelog

_A complete Changelog history can be found in [aws/eks-irsa/CHANGELOG.md](CHANGELOG.md)._

## Input Variables

_All variable details can be found in [aws/eks-irsa/variables.tf](variables.tf)._

| Variable Name               | Description                                                                                           |
|-----------------------------|-------------------------------------------------------------------------------------------------------|
| `eks_cluster`               | (Required) EKS Cluster configuration details.                                                         |
| `iam_role_name_slug`        | (Required) Name "slug" used in generating the IAM Role name.                                          |
| `iam_trust_policy_subjects` | (Required) IAM Role trust policy OIDC subjects.                                                       |
| `tags`                      | (Optional) Key-value map of resource tags to be applied to all taggable resources within this module. |

## Outputs

_All output details can be found in [aws/eks-irsa/outputs.tf](outputs.tf)._

| Variable Name          | Description                                |
|------------------------|--------------------------------------------|
| `iam_role_arn`         | Kubernetes `ServiceAccount` IAM Role ARN.  |
| `iam_role_name`        | Kubernetes `ServiceAccount` IAM Role Name. |
