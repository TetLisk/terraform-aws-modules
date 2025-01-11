# --------------------------------------------------------------------------------
# Terragrunt terraform ブロック
# @see https://terragrunt.gruntwork.io/docs/reference/config-blocks-and-attributes/#terraform
# --------------------------------------------------------------------------------

terraform {
  source = "../../../modules/ec2"
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
    ec2_security_group_id     = "sg-xxxxxxxxxxxxxxxx",
  }
}


# --------------------------------------------------------------------------------
# Terragrunt inputs ブロック
# @see https://terragrunt.gruntwork.io/docs/features/inputs/#inputs
# --------------------------------------------------------------------------------

inputs = {
  vpc_security_group_ids = [dependency.security_group.outputs.ec2_security_group_id],
}
