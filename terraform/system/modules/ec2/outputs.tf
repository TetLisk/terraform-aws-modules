# --------------------------------------------------------------------------------
# Amazon EC2 モジュール アウトプット定義
# --------------------------------------------------------------------------------
output "subnet_id" {
  value = data.aws_subnet.subnet_1.id
}

output "instance_ids" {
  value = [module.maintenance1.instance.id, module.maintenance2.instance.id]
}

output "instance_keypair" {
  value = module.maintenance_key.key_pair.id
}

output "instance_iam" {
  // 作成時にcountを使っているモジュールは配列となるため、インデックス[0]の指定が必要
  value = module.maintenance_iam.iam_instance_profile[0].name
}

output "instance_arns" {
  value = [module.maintenance1.instance.arn, module.maintenance2.instance.arn, module.windows1[0].instance.arn]
}
