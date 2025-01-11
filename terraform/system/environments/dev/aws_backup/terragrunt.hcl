# --------------------------------------------------------------------------------
# Terragrunt terraform ブロック
# @see https://terragrunt.gruntwork.io/docs/reference/config-blocks-and-attributes/#terraform
# --------------------------------------------------------------------------------

terraform {
  source = "../../../modules/aws_backup"
}

# --------------------------------------------------------------------------------
# Terragrunt include ブロック
# @see https://terragrunt.gruntwork.io/docs/reference/config-blocks-and-attributes/#include
# --------------------------------------------------------------------------------

include {
  path = find_in_parent_folders()
}

# --------------------------------------------------------------------------------
# Terragrunt dependency ブロック
# @see https://terragrunt.gruntwork.io/docs/reference/config-blocks-and-attributes/#dependency
# --------------------------------------------------------------------------------

dependency "ec2" {
  config_path = "../ec2"

  mock_outputs = {
    instance_arns  = ["arn:aws:ec2:ap-northeast-1:123456789012:instance/i-dummy",]
  }
}

dependency "rds" {
  config_path = "../rds"

  mock_outputs = {
    db_instance_arn = "arn:aws:rds:ap-northeast-1:123456789012:db:dummy-db-instance-id"
  }
}

# --------------------------------------------------------------------------------
# Terragrunt inputs ブロック
# @see https://terragrunt.gruntwork.io/docs/features/inputs/#inputs
# --------------------------------------------------------------------------------

inputs = {
  rds_instance_arn        = dependency.rds.outputs.db_instance_arn
  instance_arns           = dependency.ec2.outputs.instance_arns
}
