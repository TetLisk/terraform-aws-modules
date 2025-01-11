# --------------------------------------------------------------------------------
# Terragrunt terraform ブロック
# @see https://terragrunt.gruntwork.io/docs/reference/config-blocks-and-attributes/#terraform
# --------------------------------------------------------------------------------

terraform {
  source = "../../../modules/autoscaling"
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

dependency "security_group" {
  config_path = "../security_group"

  mock_outputs = {
    autoscaling_security_group_id     = "sg-xxxxxxxxxxxxxxxx",
  }
}

dependency "ec2" {
  config_path = "../ec2"

  mock_outputs = {
    instance_keypair  = "key-xxxxxxxxxxxxxxxx",
    instance_iam      = "xxxxxxxxxxxxxxxxxxxx",
  }
}

dependency "alb" {
  config_path = "../alb"

  mock_outputs = {
    autoscaling_target_group_id  = "arn:aws:elasticloadbalancing:ap-northeast-1:123456789012:targetgroup/dummy/xxxxxxxxxxxxxxxx",
  }
}


# --------------------------------------------------------------------------------
# Terragrunt inputs ブロック
# @see https://terragrunt.gruntwork.io/docs/features/inputs/#inputs
# --------------------------------------------------------------------------------

inputs = {
  ec2_key_pair_id = dependency.ec2.outputs.instance_keypair,
  instance_iam    = dependency.ec2.outputs.instance_iam,
  autoscaling_security_group_ids = [dependency.security_group.outputs.autoscaling_security_group_id],
  autoscaling_target_group_id = dependency.alb.outputs.autoscaling_target_group_id
}
