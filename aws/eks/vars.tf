variable "aws_region" {
  type = string
}

variable "name" {
  type = string
}

variable "vpc_name" {
  type = string
}

variable "cluster_version" {
  type    = string
  default = "1.21"
}

variable "eks_managed_node_groups" {
  description = "A list of maps defining worker group configurations to be defined using AWS Launch Configurations."
  type        = any
  default     = {}
}
