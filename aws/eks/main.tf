terraform {
  backend "s3" {
  }
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
  source = "terraform-aws-modules/eks/aws"

  cluster_version = var.cluster_version
  cluster_name    = var.name
  vpc_id          = data.aws_vpc.vpc.id
  subnets         = data.aws_subnet_ids.private_subnets.ids

  worker_groups = var.worker_groups
}

variable "worker_groups" {
  description = "A list of maps defining worker group configurations to be defined using AWS Launch Configurations."
  type        = any
  default     = []
}
