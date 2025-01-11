# --------------------------------------------------------------------------------
# Amazon ALB モジュール アウトプット定義
# --------------------------------------------------------------------------------
output "subnet_id_1" {
  value = data.aws_subnet.subnet_1.id
}

output "subnet_id_2" {
  value = data.aws_subnet.subnet_2.id
}

// cloudwatch用
output "alb_arn" {
  value = module.alb.alb.arn_suffix
}

// cloudwatch以外
output "alb_id" {
  value = module.alb.alb.arn
}

// cloudwatch用
output "target_group_arns" {
  value = [module.alb.alb_target_group.arn_suffix, module.autoscaling_target_group.alb_target_group.arn_suffix, module.p8080_target_group.alb_target_group.arn_suffix]
}

// cloudwatch以外
output "target_group_ids" {
  value = [module.alb.alb_target_group.arn, module.autoscaling_target_group.alb_target_group.arn, module.p8080_target_group.alb_target_group.arn]
}

output "autoscaling_target_group_id" {
  value = module.autoscaling_target_group.alb_target_group.arn
}
