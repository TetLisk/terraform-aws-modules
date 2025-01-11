locals {
  # IAMグループ    [環境名]-[AWSアカウント名]-[任意文字列] ※小文字
  # IAMロール      [環境名]-[AWSアカウント名/インスタンス名/アプリ名]-[サービス名]role ※小文字
  # IAMポリシー    [環境名]-[サービス名]-[任意文字列] ※小文字
  role           = "${lower(var.tags.Env)}-${lower(var.tags.Account)}-eventbridge-schedulerrole"
  policy         = "${lower(var.tags.Env)}-${lower(var.tags.Account)}-eventbridge-scheduler-policy"
}

# --------------------------------------------------------------------------------
# Maintenance EC2 Instance IAM モジュール
# @see https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group
# --------------------------------------------------------------------------------

module "scheduler_role" {
  source                      = "git::https://github.com/RITS-Cloud-Support/terraform-aws-resources.git//iam/complete2"
  tags                        = merge(var.tags, { "Name" = local.role})
  role_name                   = local.role
  role_path                   = "${path.module}/files/default_iam_assume_role.json.tpl"
  role_vars                   = {
    SERVICE = "scheduler.amazonaws.com"
  }
  create_custom_policy        = true
  policy_name                 = local.policy
  policy_path                 = "${path.module}/files/kms_used_policy.json.tpl"
  policy_vars                 = {}
  path                        = "/"
  create_iam_instance_profile = false

  # AWS Managed Policies and Custom Policy
  policies = [
    "arn:aws:iam::aws:policy/AmazonEC2FullAccess",
    module.scheduler_role.custom_policy_arn
  ]
}
