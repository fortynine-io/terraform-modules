# `aws/eks-cluster`

Terraform module for provisioning an AWS EKS Cluster and various other associated required resources.

## Design Notes

* EKS Cluster access is granted exclusively through the [EKS Cluster Access Management API][eks-access-mgmt-api] and
  callers can configure and grant cluster-level access (_for all Kubernetes namespaces_) via
  `var.cluster_access`.
  * Callers are responsible for granting access scoped to individual Kubernetes namespaces.
  * _This module does not support EKS granting access via the `aws-auth` Kubernetes `ConfigMap`._
* `var.fargate` must be set to `true` to enable the default EKS Fargate Profile for the `default` and `kube-system`
  namespaces as well as any custom, caller-defined Fargate profiles.

[eks-access-mgmt-api]: https://aws.amazon.com/blogs/containers/a-deep-dive-into-simplified-amazon-eks-access-management-controls

## Example Usage

_A complete example can be found in the [aws/eks-cluster/example](/example) directory._

```hcl
module "example" {
  source = "git::https://github.com/fortynine-io/terraform-modules.git//aws/eks-cluster?ref=aws/eks-cluster/v0.0.1"

  name            = "the-cluster"
  cluster_version = "1.34"

  kms_key_id = aws_kms_alias.test.target_key_arn

  vpc_id     = module.vpc.vpc_id

  cluster_access = {
    cluster_admin = ["arn:aws:iam::123456789101:role/terraform-builder"]
    view          = ["arn:aws:iam::123456789001:role/aws-reserved/sso.amazonaws.com/AWSReservedSSO_Administrator_af17f1238273464f"]
  }

  vpc_config = {
    subnet_ids = concat(module.vpc.private_subnets, module.vpc.database_subnets)
  }
}
```

## Provider Requirements

_All provider requirements can be found in [aws/eks-cluster/versions.tf](versions.tf)._

## Changelog

_A complete Changelog history can be found in [aws/eks-cluster/CHANGELOG.md](CHANGELOG.md)._

## Input Variables

_All variable details can be found in [aws/eks-cluster/variables.tf](variables.tf)._

| Variable Name           | Description                                                                                                            |
|-------------------------|------------------------------------------------------------------------------------------------------------------------|
| `kms_key_id`            | (Required) KMS Key ARN or Key Alias used for encryption of CloudWatch logs, EKS Cluster secrets, etc.                  |
| `name`                  | (Required) EKS Cluster name.                                                                                           |
| `subnet_ids`            | (Required) List of Subnet IDs (in at least two different AZs).                                                         |
| `vpc_id`                | (Required) ID of the VPC to associate with the EKS Cluster.                                                            |
| `auto_mode`             | (Optional) Boolean indicating whether or not to enable EKS Auto Mode for automating various cluster maintenance tasks. |
| `cluster_access`        | (Optional) Cluster-level EKS Cluster access authorization for AWS Principals.                                          |
| `cluster_version`       | (Optional) Desired Kubernetes control plane version.                                                                   |
| `fargate`               | (Optional) Boolean indicating whether or not to enable Fargate Profiles for the EKS Cluster.                           |
| `fargate_profiles`      | (Optional) Custom Fargate Profile configuration map for the EKS Cluster.                                               |
| `log_retention_in_days` | (Optional) Specifies the number of days to retain log events in the associated CloudWatch Log Group.                   |
| `log_types`             | (Optional) List desired Kubernetes Control Plane logging types to enable.                                              |
| `role_policies`         | (Optional) List of IAM Policy ARNs to attach to the EKS Cluster's IAM Role.                                            |
| `tags`                  | (Optional) Key-value map of resource tags to be applied to all taggable resources within this module.                  |
| `timeouts`              | (Optional) EKS Cluster timeouts configuration determining how long to wait for create, update, and delete processes.   |
| `upgrade_support_type`  | (Optional) EKS Cluster upgrade policy support type.                                                                    |

## Outputs

_All output details can be found in [aws/eks-cluster/outputs.tf](outputs.tf)._

| Variable Name             | Description                                                 |
|---------------------------|-------------------------------------------------------------|
| `auto_mode`               | Boolean indicating whether or not EKS Auto Mode is enabled. |
| `auto_mode_node_role`     | EKS Auto Mode Node IAM Role details.                        |
| `cloudwatch`              | Amazon CloudWatch Log Group details.                        |
| `cluster_arn`             | EKS Cluster ARN.                                            |
| `cluster_endpoint`        | EKS Cluster HTTPS endpoint.                                 |
| `cluster_name`            | EKS Cluster name.                                           |
| `cluster_oidc`            | EKS Cluster OIDC Provider properties.                       |
| `cluster_role`            | EKS Cluster IAM Role details.                               |
| `cluster_security_groups` | Configuration map for EKS Cluster-related Security Groups.  |
| `cluster_version`         | EKS Cluster version.                                        |
| `fargate_role`            | EKS Fargate Profile IAM Role details.                       |
| `k8s_auth`                | Configuration map for Kubernetes/Helm Terraform providers.  |
