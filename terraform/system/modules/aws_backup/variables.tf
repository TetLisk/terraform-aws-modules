# --------------------------------------------------------------------------------
# 属性定義
# --------------------------------------------------------------------------------

variable "hostzone" {
  type = map(string)
}

variable "tags" {
  type = map(string)
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

variable "default_kms" {
  type = map(string)
}


# --------------------------------------------------------------------------------
# ec2/rdsモジュール属性定義
# --------------------------------------------------------------------------------
variable "instance_arns" {
  type = list(string)
}

variable "rds_instance_arn" {
  type = string
  default = null
}
