locals {
  # ボールト  [環境名]-[サービス名/システムアプリ名称]-[任意文字列]-BACKUP-VAULT
  # プラン    [環境名]-[EC2名]-BACKUP-PLAN
  vault       = "${var.tags.Env}-${var.tags.System}-BACKUP-VAULT"
  plan        = "${var.tags.Env}-INSTANCE-BACKUP-PLAN"
}

module "aws_backup" {
  source = "git::https://github.com/RITS-Cloud-Support/terraform-aws-resources.git//aws_backup"

  vault_name        = local.vault
  backup_plan_name  = local.plan
  kms_key_arn       = "${var.default_kms.id}"

  backup_rules = [
    {
      rule_name         = "${var.tags.Env}-${var.tags.System}-BACKUP-RULE"
      schedule          = "cron(20 7 ? * MON-FRI *)" # UTC時間で記載する (UTC時間 + 9時間 = 日本時間)
      start_window      = 60
      completion_window = 120
      delete_after      = 7
    }
  ]

  backup_selections = [
    {
      iam_role_arn = module.aws_backup_iam.iam_role.arn
      name         = "${var.tags.Env}-${var.tags.System}-BACKUP-TARGET"
      resources    = concat(var.instance_arns, [var.rds_instance_arn])
        //var.rds_instance_arn
    }
  ]
}
