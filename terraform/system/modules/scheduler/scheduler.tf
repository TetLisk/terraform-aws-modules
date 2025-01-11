locals {
  # キーペア    [環境名]_[処理動作]_[インスタンス名]_[任意文字列]
  # グループ名  [サービス名/システムアプリ名称]_[任意文字列]
  ec2-start         = "${var.tags.Env}_ec2start_APT1_am9"
  ec2-stop          = "${var.tags.Env}_ec2stop_APT1_pm9"
  group       = "${var.tags.System}_Auto_Start_Stop"
}

module "ec2_schedulers" {
  source               = "git::https://github.com/RITS-Cloud-Support/terraform-aws-resources.git//eventbridge/scheduler_test"
  schedule_group_name  = local.group
  schedules = [
    {
      name                         = local.ec2-start
      description                  = "Start EC2 instances"
      schedule_expression          = "cron(0 9 * * ? *)" # 毎日午前9時に実行
      schedule_expression_timezone = "Asia/Tokyo"
      start_date                   = null
      end_date                     = null
      kms_key_arn                  = null
      target_arn                   = "arn:aws:scheduler:::aws-sdk:ec2:startInstances"
      role_arn                     = module.scheduler_role.iam_role_arn
      target_input                 = jsonencode({ "InstanceIds": ["${var.instance_ids[0]}"] })
      group_name                   = local.group
      retry_policy                 = null
      dead_letter_config           = null
    },
    {
      name                         = local.ec2-stop
      description                  = "Stop EC2 instances"
      schedule_expression          = "cron(0 21 * * ? *)" # 毎日午後21時に実行
      schedule_expression_timezone = "Asia/Tokyo"
      start_date                   = null
      end_date                     = null
      kms_key_arn                  = null
      target_arn                   = "arn:aws:scheduler:::aws-sdk:ec2:stopInstances"
      role_arn                     = module.scheduler_role.iam_role_arn
      target_input                 = jsonencode({ "InstanceIds": ["${var.instance_ids[0]}"] })
      group_name                   = local.group
      retry_policy                 = null
      dead_letter_config           = null
    }
  ]
}
