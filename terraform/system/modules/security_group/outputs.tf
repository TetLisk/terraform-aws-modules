# --------------------------------------------------------------------------------
# Security Group モジュール アウトプット定義
# --------------------------------------------------------------------------------
output "vpc_id" {
  value = data.aws_vpc.vpc.id
}

output "ec2_security_group_id" {
  value = module.ec2_sg.security_group.id
}

output "autoscaling_security_group_id" {
  value = module.autoscaling_sg.security_group.id
}

output "rds_security_group_id" {
  value = module.rds_sg.security_group.id
}

output "efs_security_group_id" {
  value = module.efs_sg.security_group.id
}

output "alb_security_group_id" {
  value = module.alb_sg.security_group.id
}
