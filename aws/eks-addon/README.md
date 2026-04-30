# `aws/eks-addon`

Terraform Module for provisioning an EKS-managed add-on. This module supports the creation of _all EKS-managed add-ons_
without Kubernetes IRSA requirements. Additionally, a limited number of add-ons that _require Kubernetes IRSA_
_configuration are supported_.

## Design Notes

* For EKS-managed add-ons that require permissions granted via IRSA, this module provisions the necessary IAM Role
  resources and configures `aws_eks_addon.service_account_role_arn`.
* Currently, the following EKS-managed add-ons requiring IRSA are supported:
  * `amazon-cloudwatch-observability`
  * `aws-ebs-csi-driver`
  * `aws-efs-csi-driver`
  * `vpc-cni`
* When provisioning EKS-managed add-ons as part of initial EKS cluster creation, _you must also provision one or more_
  _EKS Node Groups or Fargate Profiles_ so there is available compute capacity to service the desired add-ons. If no
  compute capacity is provisioned, the EKS-managed add-ons will fail to launch in a healthy state prior to the
  expiration of their create timeout window.

## References

* [AWS Docs: EKS Add-Ons][aws-docs-eks-addons]
* [AWS CLI: `aws eks describe-addon-versions`][aws-cli-describe-addon-versions]
* [AWS CLI: `aws eks describe-addon-configuration`][aws-cli-describe-addon-configuration]

* [aws-docs-eks-addons]: https://docs.aws.amazon.com/eks/latest/userguide/eks-add-ons.html
* [aws-cli-describe-addon-versions]: https://awscli.amazonaws.com/v2/documentation/api/latest/reference/eks/describe-addon-versions.html
* [aws-cli-describe-addon-configuration]: https://awscli.amazonaws.com/v2/documentation/api/latest/reference/eks/describe-addon-configuration.html

## Example Usage

### Module: No IRSA Requirement

```hcl
module "eks_addon" {
  source = "git::https://github.com/fortynine-io/terraform-modules.git//aws/eks-addon?ref=aws/eks-addon/v0.1.1"

  name          = "coredns"
  addon_version = "v1.14.2-eksbuild.4"

  cluster_name  = "your-eks-cluster-name"

  tags = local.default_tags
}
```

### Module: IRSA Required

```hcl
module "eks_addon" {
  source = "git::https://github.com/fortynine-io/terraform-modules.git//aws/eks-addon?ref=aws/eks-addon/v0.1.1"

  name          = "aws-ebs-csi-driver"
  addon_version = "v1.59.0-eksbuild.1"

  cluster_name = "your-eks-cluster-name"
  cluster_oidc = {
    arn = "arn:aws:iam::000000000000:oidc-provider/oidc.eks.us-east-1.amazonaws.com/id/ABCDEFABDCDFABCDEFABCDEFABCDEFAB"
    url = "oidc.eks.us-east-1.amazonaws.com/id/ABCDEFABDCDFABCDEFABCDEFABCDEFAB"
  }

  tags = local.default_tags
}
```

## Provider Requirements

_All provider requirements can be found in [aws/eks-addon/versions.tf](versions.tf)._

## Input Variables

_All variable details can be found in [aws/eks-addon/variables.tf](variables.tf)._

| Variable Name          | Description                                                                                                                |
|------------------------|----------------------------------------------------------------------------------------------------------------------------|
| `addon_version`        | (Required) EKS-managed add-on version.                                                                                     |
| `cluster_name`         | (Required) Host EKS Cluster name.                                                                                          |
| `name`                 | (Required) EKS-managed add-on name.                                                                                        |
| `cluster_oidc`         | (Optional) Host EKS Cluster IAM OIDC Provider details (necessary for add-ons with IRSA config requirements).               |
| `configuration_values` | (Optional) EKS-managed add-on configuration values JSON string.                                                            |
| `tags`                 | (Optional) Key-value map of resource tags to be applied to all taggable resources within this module.                      |
| `timeouts`             | (Optional) EKS-managed add-on timeouts configuration indicating how long to wait for create, update and delete operations. |

## Outputs

_All output details can be found in [aws/eks-addon/outputs.tf](outputs.tf)._

| Variable Name | Description                                         |
|---------------|-----------------------------------------------------|
| `arn`         | EKS-managed add-on ARN.                             |
| `created_at`  | EKS-managed add-on created-at [RFC3339] timestamp.  |
| `id`          | EKS-managed add-on ID.                              |
| `irsa`        | EKS-managed add-on IRSA details.                    |
| `modified_at` | EKS-managed add-on modified-at [RFC3339] timestamp. |
| `name`        | EKS-managed add-on name.                            |
