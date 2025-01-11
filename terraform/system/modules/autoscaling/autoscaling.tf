locals {
  # オートスケーリンググループ名  [環境名]-[AWSアカウント名]-ASG
  # APサーバ                    [環境名]-[サービス名/システムアプリ名称]-[製品名][任意文字列]
  # アンダーバーは原則禁止
  asg           = "${var.tags.Env}-${var.tags.System}-ASG"
  instance_name = "${var.tags.Env}-${var.tags.System}-APT-ASG"
}

# --------------------------------------------------------------------------------
# Maintenance EC2 Instance Key Pair モジュール
# @see https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/instance
# --------------------------------------------------------------------------------

module "autoscaling" {
  //起動テンプレート設定
  source                      = "git::https://github.com/RITS-Cloud-Support/terraform-aws-resources.git//autoscaling/complete/"
  tags                        = merge(var.tags, { "Name" = local.asg })
  launch_template_name        = "${local.asg}-TEMPLATE"
  block_device_mappings       = [
                                  {
                                    device_name  = null
                                    no_device    = null
                                    virtual_name = null
                                    ebs          = []
                                  }
                                ]
  image_id                    = "ami-0c0d0a2b40dfcef33" # 検証用AMI ※本番デプロイの際は変更すること
  instance_type               = "m7a.medium"
  key_name                    = var.ec2_key_pair_id
  user_data                   = base64encode(file("${path.module}/files/user_data/rhel-instance.sh")) //rhelのみ利用可能
  tag_specifications          = var.tags
  instance_profile_name       = var.instance_iam
  device_index                = 0
  associate_public_ip_address = false
  eni_delete_on_termination   = true
  security_group_ids          = var.autoscaling_security_group_ids

  //Auto Scaling Group設定
  autoscaling_group_name      = local.asg
  instance_name               = local.instance_name
  subnet_ids                  = var.tags.Env == "P" ? [ "${data.aws_subnet.subnet_1.id}", "${data.aws_subnet.subnet_2.id}" ] : [ "${data.aws_subnet.subnet_1.id}" ]
  desired_capacity            = var.tags.Env == "P" ? 2 : 1
  min_size                    = var.tags.Env == "P" ? 2 : 1
  max_size                    = var.tags.Env == "P" ? 2 : 1
  health_check_grace_period   = 300
  health_check_type           = "ELB"
  min_elb_capacity            = 0
  wait_for_elb_capacity       = 0
  #target_group_arns           = [ "${module.autoscaling_target_group.alb_target_group.arn}" ]
  default_cooldown            = 300
  force_delete                = true
  termination_policies        = []
  suspended_processes         = []
  placement_group             = null
  enabled_metrics             = [
                                  "GroupMinSize",
                                  "GroupMaxSize",
                                  "GroupDesiredCapacity",
                                  "GroupInServiceInstances",
                                  "GroupPendingInstances",
                                  "GroupStandbyInstances",
                                  "GroupTerminatingInstances",
                                  "GroupTotalInstances",
                                ]
  metrics_granularity         = "1Minute"
  wait_for_capacity_timeout   = "10m"
  protect_from_scale_in       = null
  service_linked_role_arn     = null
  alb_target_group_arn        = var.autoscaling_target_group_id
  autoscaling_policies        = []
  cloudwatch_metric_alarms    = {}
}
