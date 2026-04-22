resource "aws_security_group" "cluster" {
  name_prefix = "${var.name}-cluster-"
  description = "EKS Cluster [${var.name}] primary SG for intra-node communication."
  vpc_id      = var.vpc_id

  tags = merge(local.default_tags, { "Name" = var.name })

  ingress {
    description = "Allow ALL intra-group ingress."
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    self        = true
  }

  egress {
    description = "Allow ALL intra-group egress."
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    self        = true
  }

  lifecycle {
    create_before_destroy = true
  }
}
