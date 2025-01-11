# --------------------------------------------------------------------------------
# Terragrunt terraform ブロック
# @see https://terragrunt.gruntwork.io/docs/reference/config-blocks-and-attributes/#terraform
# --------------------------------------------------------------------------------

terraform {
  source = "../../../modules/cloudwatch"
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
    instance_ids  = ["i-xxxxxxxxxxxxxxxxx",]
  }
}

dependency "rds" {
  config_path = "../rds"
  mock_outputs = {
    db_instance_id = "dummy-db-instance-id",
  }
}

dependency "alb" {
  config_path = "../alb"
  mock_outputs = {
    alb_arn = "loadbalancer/app/dummy-alb-id",
    target_group_arns = ["targetgroup/dummy/xxxxxxxxxxxxxxxx",]
  }
}

# --------------------------------------------------------------------------------
# Terragrunt inputs ブロック
# @see https://terragrunt.gruntwork.io/docs/features/inputs/#inputs
# --------------------------------------------------------------------------------

inputs = {
  instance_ids      = dependency.ec2.outputs.instance_ids
  db_instance_id    = dependency.rds.outputs.db_instance_id
  alb_arn           = dependency.alb.outputs.alb_arn
  target_group_arns = dependency.alb.outputs.target_group_arns
}
