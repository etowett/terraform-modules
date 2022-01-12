provider "aws" {
  region = var.aws_region
}

terraform {
  backend "s3" {}
}


data "aws_vpc" "vpc" {
  filter {
    name   = "tag:Name"
    values = [var.vpc_name]
  }
}

data "aws_subnet_ids" "private_subnets" {
  vpc_id = data.aws_vpc.vpc.id

  filter {
    name   = "tag:Name"
    values = ["${var.vpc_name}-private-${var.aws_region}*"]
  }
}

module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 18.0"

  cluster_version = var.cluster_version
  cluster_name    = var.name

  cluster_endpoint_private_access = true
  cluster_endpoint_public_access  = true

  vpc_id     = data.aws_vpc.vpc.id
  subnet_ids = data.aws_subnet_ids.private_subnets.ids

  eks_managed_node_groups = var.eks_managed_node_groups
}
