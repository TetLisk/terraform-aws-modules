locals {
  # IAMグループ    [環境名]-[AWSアカウント名]-[任意文字列] ※小文字
  # IAMロール      [環境名]-[AWSアカウント名/インスタンス名/アプリ名]-[サービス名]role ※小文字
  # IAMポリシー    [環境名]-[サービス名]-[任意文字列] ※小文字
  role           = "${lower(var.tags.Env)}-${lower(var.tags.Account)}-backuprole"
}

# --------------------------------------------------------------------------------
# Maintenance backup Instance IAM モジュール
# @see https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group
# --------------------------------------------------------------------------------

module "aws_backup_iam" {
  source        = "git::https://github.com/RITS-Cloud-Support/terraform-aws-resources.git//iam/role"
  tags          = merge(var.tags, { "Name" = local.role})
  name          = local.role
  path          = "${path.module}/files/template/default_iam_assume_role.json.tpl"

  vars = {
    SERVICE = "backup.amazonaws.com"
  }

  policies = [
    "arn:aws:iam::aws:policy/service-role/AWSBackupServiceRolePolicyForBackup",
    "arn:aws:iam::aws:policy/service-role/AWSBackupServiceRolePolicyForRestores"
  ]
}
