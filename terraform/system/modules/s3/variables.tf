# --------------------------------------------------------------------------------
# 属性定義
# --------------------------------------------------------------------------------

variable "tags" {
  type = map(string)
}

variable "account" {
  type = map(string)
}

variable "default_kms" {
  type = map(string)
}