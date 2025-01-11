locals {
  account_id        = "421340346768"
  Env               = "S"
  System            = "POC"
  Name              = ""
  Account           = "CP050"
  hostzone          = null
  product           = null
  region            = "ap-northeast-1"
  vpc               = "M1-Cp050-rcloud-support"
  subnet_1          = "M1-Cp050-rcloud-support-subnet-1a"
  subnet_2          = "M1-Cp050-rcloud-support-subnet-1c"
  default_kms       = "arn:aws:kms:ap-northeast-1:421340346768:key/21b995a0-45a3-422d-aa71-8726b0ee131c"
}

# ${var.tags.Env}-${var.tags.System}-[任意の値] 基本の並び
