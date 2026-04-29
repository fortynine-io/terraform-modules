locals {
  cluster_admin_arns = try(var.cluster_access.cluster_admin, [])
  admin_arns         = try(var.cluster_access.admin, [])
  edit_arns          = try(var.cluster_access.edit, [])
  view_arns          = try(var.cluster_access.view, [])
  principal_arns     = concat(local.cluster_admin_arns, local.admin_arns, local.edit_arns, local.view_arns)
}



resource "aws_eks_access_entry" "aws_principal" {
  for_each = toset(local.principal_arns)

  cluster_name  = aws_eks_cluster.default.name
  principal_arn = each.value
}



resource "aws_eks_access_policy_association" "cluster_admin" {
  for_each = toset(local.cluster_admin_arns)

  cluster_name  = aws_eks_cluster.default.name
  policy_arn    = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSClusterAdminPolicy"
  principal_arn = each.value

  access_scope {
    type = "cluster"
  }
}

resource "aws_eks_access_policy_association" "admin" {
  for_each = toset(local.admin_arns)

  cluster_name  = aws_eks_cluster.default.name
  policy_arn    = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSAdminPolicy"
  principal_arn = each.value

  access_scope {
    type = "cluster"
  }
}

resource "aws_eks_access_policy_association" "edit" {
  for_each = toset(local.edit_arns)

  cluster_name  = aws_eks_cluster.default.name
  policy_arn    = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSEditPolicy"
  principal_arn = each.value

  access_scope {
    type = "cluster"
  }
}

resource "aws_eks_access_policy_association" "view" {
  for_each = toset(local.view_arns)

  cluster_name  = aws_eks_cluster.default.name
  policy_arn    = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSViewPolicy"
  principal_arn = each.value

  access_scope {
    type = "cluster"
  }
}
