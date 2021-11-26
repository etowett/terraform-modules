variable "name" {
  type = string
}

variable "cluster_version" {
  type    = string
  default = "1.21"
}

variable "vpc_name" {
  type = string
}

variable "worker_groups" {
  type = list(any)
}
