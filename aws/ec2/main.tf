provider "aws" {
  region = var.aws_region
}

terraform {
  backend "s3" {}
}

data "aws_vpc" "vpc" {
  tags = {
    Name = var.vpc_name
  }
}

data "aws_subnet_ids" "subnet_ids" {
  vpc_id = data.aws_vpc.vpc.id

  tags = {
    Name = "*${var.subnet_filter}*"
  }
}

module "ec2-instance" {
  source                      = "terraform-aws-modules/ec2-instance/aws"
  version                     = "~> 3.0"
  name                        = var.name
  count                       = var.instance_count
  ami                         = var.ami_id
  associate_public_ip_address = var.associate_public_ip
  disable_api_termination     = false
  instance_type               = var.instance_type
  key_name                    = var.key_name
  user_data                   = var.user_data
  monitoring                  = true
  subnet_id                   = sort(data.aws_subnet_ids.subnet_ids.ids)[0]

  vpc_security_group_ids = [
    aws_security_group.ec2-instance-sg.id
  ]

  root_block_device = [
    {
      volume_size           = var.root_device_size
      volume_type           = "gp2"
      delete_on_termination = var.delete_on_termination
    },
  ]

  tags = var.tags
}

resource "aws_security_group_rule" "sg_rules" {
  count = length(var.sg_rules)

  type              = var.sg_rules[count.index].type
  from_port         = var.sg_rules[count.index].from_port
  to_port           = var.sg_rules[count.index].to_port
  protocol          = var.sg_rules[count.index].protocol
  cidr_blocks       = [var.sg_rules[count.index].cidr_block]
  description       = var.sg_rules[count.index].description
  security_group_id = aws_security_group.ec2-instance-sg.id
}

resource "aws_security_group" "ec2-instance-sg" {
  name        = "${var.name}_sg"
  description = "${var.name} SG "
  vpc_id      = data.aws_vpc.vpc.id

  tags = {
    Name = "${var.name}_sg"
  }
}
