# --------------------------------------------------------------------------------
# Terragrunt terraform ブロック
# @see https://terragrunt.gruntwork.io/docs/reference/config-blocks-and-attributes/#terraform
# --------------------------------------------------------------------------------

terraform {
  source = "../../../modules/alb"
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
    alb_security_group_id = "sg-xxxxxxxxxxxxxxxx",
  }
}

dependency "ec2" {
  config_path = "../ec2"

  mock_outputs = {
    instance_ids  = ["i-xxxxxxxxxxxxxxxxx",]
  }
}

# --------------------------------------------------------------------------------
# Terragrunt inputs ブロック
# @see https://terragrunt.gruntwork.io/docs/features/inputs/#inputs
# --------------------------------------------------------------------------------

inputs = {
  vpc_security_group_ids = [
    dependency.security_group.outputs.alb_security_group_id,
    ]

  ec2_ids = dependency.ec2.outputs.instance_ids,
}
