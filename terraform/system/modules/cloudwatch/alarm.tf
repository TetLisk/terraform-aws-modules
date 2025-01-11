locals {
  # EC2    [障害レベル]-ec2-[EC2名]
  ec2         = "TEST-ec2-APT_CPUUtilization_over"
}

module "cloudwatch_metric_alarms" {
  source     = "git::https://github.com/RITS-Cloud-Support/terraform-aws-resources.git//cloudwatch/metric_alarm"

  metric_alarms = [
    {
      alarm_name          = "${var.tags.Env}-${var.tags.System}-EC2_CPUUtilization"
      alarm_description   = "Alarm when EC2 instance CPU utilization exceeds threshold"
      comparison_operator = "GreaterThanThreshold"
      evaluation_periods  = 2
      metric_name         = "CPUUtilization"
      namespace           = "AWS/EC2"
      period              = 300
      statistic           = "Average"
      threshold           = 80
      actions_enabled     = true
      alarm_actions       = ["${module.sns_topic.sns_topic.arn}"]
      dimensions          = {
        InstanceId = var.instance_ids[0]
      }
      ok_actions          = ["${module.sns_topic.sns_topic.arn}"]
      insufficient_data_actions = ["${module.sns_topic.sns_topic.arn}"]
      treat_missing_data  = "missing"
    },
    {
      alarm_name          = "${var.tags.Env}-${var.tags.System}-EC2_StatusCheckFailed"
      alarm_description   = "Alarm when EC2 instance status check fails"
      comparison_operator = "GreaterThanThreshold"
      evaluation_periods  = 2
      metric_name         = "StatusCheckFailed"
      namespace           = "AWS/EC2"
      period              = 300
      statistic           = "Maximum"
      threshold           = 0.5
      actions_enabled     = true
      alarm_actions       = ["${module.sns_topic.sns_topic.arn}"]
      dimensions          = {
        InstanceId = var.instance_ids[0]
      }
      ok_actions          = ["${module.sns_topic.sns_topic.arn}"]
      insufficient_data_actions = ["${module.sns_topic.sns_topic.arn}"]
      treat_missing_data  = "missing"
    },
    {
      alarm_name          = "${var.tags.Env}-${var.tags.System}-RDS_CPUUtilization"
      alarm_description   = "Alarm when RDS instance CPU utilization exceeds threshold"
      comparison_operator = "GreaterThanThreshold"
      evaluation_periods  = 2
      metric_name         = "CPUUtilization"
      namespace           = "AWS/RDS"
      period              = 300
      statistic           = "Average"
      threshold           = 80
      actions_enabled     = true
      alarm_actions       = ["${module.sns_topic.sns_topic.arn}"]
      dimensions          = {
        DBInstanceIdentifier = var.db_instance_id
      }
      ok_actions          = ["${module.sns_topic.sns_topic.arn}"]
      insufficient_data_actions = ["${module.sns_topic.sns_topic.arn}"]
      treat_missing_data  = "missing"
    },
    {
      alarm_name          = "${var.tags.Env}-${var.tags.System}-RDS_FreeableMemory"
      alarm_description   = "Alarm when RDS instance freeable memory is below threshold"
      comparison_operator = "LessThanThreshold"
      evaluation_periods  = 2
      metric_name         = "FreeableMemory"
      namespace           = "AWS/RDS"
      period              = 300
      statistic           = "Average"
      threshold           = 500000000 #500MB
      actions_enabled     = true
      alarm_actions       = ["${module.sns_topic.sns_topic.arn}"]
      dimensions          = {
        DBInstanceIdentifier = var.db_instance_id
      }
      ok_actions          = ["${module.sns_topic.sns_topic.arn}"]
      insufficient_data_actions = ["${module.sns_topic.sns_topic.arn}"]
      treat_missing_data  = "missing"
    },
    {
      alarm_name          = "${var.tags.Env}-${var.tags.System}-RDS_FreeStorageSpace"
      alarm_description   = "Alarm when RDS instance free storage space is below threshold"
      comparison_operator = "LessThanThreshold"
      evaluation_periods  = 2
      metric_name         = "FreeStorageSpace"
      namespace           = "AWS/RDS"
      period              = 300
      statistic           = "Average"
      threshold           = 10000000000 #10GB
      actions_enabled     = true
      alarm_actions       = ["${module.sns_topic.sns_topic.arn}"]
      dimensions          = {
        DBInstanceIdentifier = var.db_instance_id
      }
      ok_actions          = ["${module.sns_topic.sns_topic.arn}"]
      insufficient_data_actions = ["${module.sns_topic.sns_topic.arn}"]
      treat_missing_data  = "missing"
    },
    {
      alarm_name          = "${var.tags.Env}-${var.tags.System}-ALB_UnHealthyHostCount"
      alarm_description   = "Alarm when ALB has unhealthy hosts"
      comparison_operator = "GreaterThanThreshold"
      evaluation_periods  = 2
      metric_name         = "UnHealthyHostCount"
      namespace           = "AWS/ApplicationELB"
      period              = 300
      statistic           = "Average"
      threshold           = 0.5
      actions_enabled     = true
      alarm_actions       = ["${module.sns_topic.sns_topic.arn}"]
      dimensions          = {
        LoadBalancer = var.alb_arn
        TargetGroup  = var.target_group_arns[0]
      }
      ok_actions          = ["${module.sns_topic.sns_topic.arn}"]
      insufficient_data_actions = ["${module.sns_topic.sns_topic.arn}"]
      treat_missing_data  = "missing"
    }
  ]

  tags = var.tags
}
