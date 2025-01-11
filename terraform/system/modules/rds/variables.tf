# --------------------------------------------------------------------------------
# 属性定義
# --------------------------------------------------------------------------------

variable "hostzone" {
  type = map(string)
}

variable "password" {
  type = string
}

variable "username" {
  type = string
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
# rdsモジュール属性定義
# --------------------------------------------------------------------------------

variable "database_name" {
  type = string
}

# --------------------------------------------------------------------------------
# security_groupモジュール属性定義
# --------------------------------------------------------------------------------

variable "vpc_security_group_ids" {
  type = list(string)
}