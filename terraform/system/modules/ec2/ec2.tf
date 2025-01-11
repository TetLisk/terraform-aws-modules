locals {
  # キーペア    [環境名]-[AWSアカウント名]-keypair ※小文字
  # APサーバ    [環境名]-[サービス名/システムアプリ名称]-[製品名][任意文字列]
  # HULFTサーバ [環境名]-[AWSアカウント名]-[製品名][任意文字列]
  # アンダーバーは原則禁止
  keypair         = "${lower(var.tags.Env)}-${lower(var.tags.Account)}-keypair"
  maintenance1        = "${var.tags.Env}-${var.tags.System}-APT1"
  maintenance2        = "${var.tags.Env}-${var.tags.System}-APT2"
  windows1        = "${var.tags.Env}-${var.tags.System}-WIN1"
}

# --------------------------------------------------------------------------------
# Maintenance EC2 Instance Key Pair モジュール
# @see https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/key_pair
# --------------------------------------------------------------------------------

module "maintenance_key" {
  source     = "git::https://github.com/RITS-Cloud-Support/terraform-aws-resources.git//key_pair"
  tags       = merge(var.tags, { "Name" = local.keypair })
  key_name   = local.keypair
  public_key = file("${path.module}/files/keypair/${local.keypair}.pub")
}

# --------------------------------------------------------------------------------
# Maintenance EC2 Instance Key Pair モジュール
# @see https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/instance
# --------------------------------------------------------------------------------

module "maintenance1" {
  source                      = "git::https://github.com/RITS-Cloud-Support/terraform-aws-resources.git//ec2"
  tags                        = merge(var.tags, { "Name" = local.maintenance1 })
  name                        = local.maintenance1
  associate_public_ip_address = false
  ami                         = "ami-0c0d0a2b40dfcef33" //Redhat9
  iam_instance_profile        = module.maintenance_iam.iam_instance_profile[0].name
  instance_type               = "r7a.medium"
  key_name                    = module.maintenance_key.key_pair.id
  subnet_id                   = data.aws_subnet.subnet_1.id
  vpc_security_group_ids      = var.vpc_security_group_ids
  volume_size                 = 100
  encrypted                   = true
  kms_key_arn                 = "${var.default_kms.id}"
  user_data                   = file("${path.module}/files/user_data/rhel-instance.sh") //rhelの場合
}

module "maintenance2" {
  source                      = "git::https://github.com/RITS-Cloud-Support/terraform-aws-resources.git//ec2"
  tags                        = merge(var.tags, { "Name" = local.maintenance2 })
  name                        = local.maintenance2
  associate_public_ip_address = false
  ami                         = "ami-0c0d0a2b40dfcef33" //Redhat9
  iam_instance_profile        = module.maintenance_iam.iam_instance_profile[0].name
  instance_type               = "r7a.medium"
  key_name                    = module.maintenance_key.key_pair.id
  subnet_id                   = data.aws_subnet.subnet_2.id
  vpc_security_group_ids      = var.vpc_security_group_ids
  volume_size                 = 100
  encrypted                   = true
  kms_key_arn                 = "${var.default_kms.id}"
  user_data                   = file("${path.module}/files/user_data/rhel-instance.sh") //rhelの場合
}

module "windows1" {
  count                       = var.tags.Env == "S" ? 1 : 0 //sgtの場合のみ作成
  source                      = "git::https://github.com/RITS-Cloud-Support/terraform-aws-resources.git//ec2"
  tags                        = merge(var.tags, { "Name" = local.windows1 })
  name                        = local.windows1
  associate_public_ip_address = false
  ami                         = "ami-0aa3165ff2581ca10" //Windows2022
  iam_instance_profile        = module.maintenance_iam.iam_instance_profile[0].name
  instance_type               = "r7a.medium"
  key_name                    = module.maintenance_key.key_pair.id
  subnet_id                   = data.aws_subnet.subnet_1.id
  vpc_security_group_ids      = var.vpc_security_group_ids
  volume_size                 = 100
  encrypted                   = true
  kms_key_arn                 = "${var.default_kms.id}"
  user_data                   = file("${path.module}/files/user_data/win2022-instance.sh") //rhelの場合
}
