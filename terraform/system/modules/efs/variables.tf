# --------------------------------------------------------------------------------
# 属性定義
# --------------------------------------------------------------------------------

variable "tags" {
  type = map(string)
}

# --------------------------------------------------------------------------------
# Amazon EFS Mount Target 属性定義
# @see https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/efs_mount_target
# --------------------------------------------------------------------------------

variable "subnet_ids" {
  type    = list(string)
  default = []
}

variable "vpc" {
  type = map(string)
}

variable "subnet_1" {
  type = map(string)
}

variable "subnet_2" {
  type = map(string)
}

variable "vpc_security_group_ids" {
  type = list(string)
}

variable "status" {
  type    = string
  default = "DISABLED"
}
