locals {
  # ファイルシステム名  [環境名]-[AWSアカウント名]-[製品/用途名]-EFS-[任意文字列]
  efs             = "${var.tags.Env}-${var.tags.Account}-APT-EFS-FILE"
}

module "efs" {
  source                 = "git::https://github.com/RITS-Cloud-Support/terraform-aws-resources.git//efs"
# --------------------------------------------------------------------------------
# Amazon EFS 属性定義
# @see https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/efs_file_system
# --------------------------------------------------------------------------------
  tags                   = merge(var.tags, { "Name" = local.efs})
  name                   = local.efs
#  creation_token         =
  encrypted              = true
  performance_mode       = "generalPurpose"
#  provisioned_throughput_in_mibps =
  throughput_mode        = "bursting"
  subnet_ids             = [ "${data.aws_subnet.subnet_1.id}", "${data.aws_subnet.subnet_2.id}" ]

# --------------------------------------------------------------------------------
# Amazon EFS Mount Target リソース定義
# @see https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/efs_mount_target
# --------------------------------------------------------------------------------
  security_groups = var.vpc_security_group_ids

# --------------------------------------------------------------------------------
# Amazon EFS Backup Policy リソース定義
# @see https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/efs_backup_policy
# --------------------------------------------------------------------------------
  status = "DISABLED" # Replace with "ENABLED" if you want to enable backups
}
