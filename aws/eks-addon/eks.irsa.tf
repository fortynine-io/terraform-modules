locals {
  irsa_options = {
    "amazon-cloudwatch-observability" = {
      policy_arns = [
        "arn:aws:iam::aws:policy/AWSXrayWriteOnlyAccess",
        "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy"
      ]
      service_account_name = "cloudwatch-agent"
      namespace            = "amazon-cloudwatch"
    }
    "aws-ebs-csi-driver" = {
      policy_arns          = ["arn:aws:iam::aws:policy/service-role/AmazonEBSCSIDriverPolicy"]
      service_account_name = "ebs-csi-controller-sa"
      namespace            = "kube-system"
    }
    "aws-efs-csi-driver" = {
      policy_arns          = ["arn:aws:iam::aws:policy/service-role/AmazonEFSCSIDriverPolicy"]
      service_account_name = "efs-csi-controller-sa"
      namespace            = "kube-system"
    }
    "vpc-cni" = {
      policy_arns          = ["arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"]
      service_account_name = "aws-node"
      namespace            = "kube-system"
    }
  }

  irsa_config   = lookup(local.irsa_options, var.name, {})
  requires_irsa = (lookup(local.irsa_options, var.name, null) != null) ? ["true"] : []
  policy_arns   = try(local.irsa_options[var.name].policy_arns, [])
}


module "irsa" {
  # see: https://github.com/fortynine-io/terraform-modules/tags
  # aws/eks-irsa/v0.1.0: 08a1187934c86750c0b33711fcdcd4b9a7389836
  source = "git::https://github.com/fortynine-io/terraform-modules.git//aws/eks-irsa?ref=08a1187934c86750c0b33711fcdcd4b9a7389836"

  for_each = toset(local.requires_irsa)

  eks_cluster = {
    name = var.cluster_name
    oidc = var.cluster_oidc
  }

  description = "EKS Add-on (${var.name})"
  name_slug   = local.irsa_config.service_account_name

  trust_policy_subjects = {
    exact_match = [
      "system:serviceaccount:${local.irsa_config.namespace}:${local.irsa_config.service_account_name}"
    ]
  }

  tags = local.default_tags
}

resource "aws_iam_role_policy_attachment" "irsa" {
  for_each = toset(local.policy_arns)

  role       = module.irsa["true"].name
  policy_arn = each.value
}
