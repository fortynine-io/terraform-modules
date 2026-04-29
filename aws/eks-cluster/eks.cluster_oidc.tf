data "aws_eks_cluster_auth" "default" {
  name = aws_eks_cluster.default.name
}

data "tls_certificate" "default" {
  url = aws_eks_cluster.default.identity[0].oidc[0].issuer
}

resource "aws_iam_openid_connect_provider" "default" {
  client_id_list  = ["sts.amazonaws.com"]
  thumbprint_list = [data.tls_certificate.default.certificates[0].sha1_fingerprint]
  url             = aws_eks_cluster.default.identity[0].oidc[0].issuer

  tags = merge(local.default_tags, { Name = "eks-irsa-${var.name}" })
}
