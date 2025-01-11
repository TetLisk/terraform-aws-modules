# --------------------------------------------------------------------------------
# Amazon RDS for Microsoft SQLServer モジュール アウトプット定義
# --------------------------------------------------------------------------------
output "subnet_id" {
  value = data.aws_subnet.subnet_1.id
}

output "db_instance_arn" {
  value = module.rds.db_instance.arn
}

output "db_instance_id" {
  value = module.rds.db_instance.id
}
