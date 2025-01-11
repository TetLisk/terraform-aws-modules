# --------------------------------------------------------------------------------
# ローカル属性定義
# --------------------------------------------------------------------------------

locals {
  environment_vars = read_terragrunt_config(find_in_parent_folders("env.hcl"))
  aws_account_id   = local.environment_vars.locals.account_id
  aws_region_id    = "ap-northeast-1"
  Name             = local.environment_vars.locals.Name
  Env              = local.environment_vars.locals.Env
  System           = local.environment_vars.locals.System
  Account          = local.environment_vars.locals.Account
  hostzone         = local.environment_vars.locals.hostzone
  vpc              = local.environment_vars.locals.vpc
  subnet_1         = local.environment_vars.locals.subnet_1
  subnet_2         = local.environment_vars.locals.subnet_2
  default_kms      = local.environment_vars.locals.default_kms
}

# --------------------------------------------------------------------------------
# provider.tf テンプレート
# --------------------------------------------------------------------------------

generate "provider" {
  path      = "provider.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<EOF
provider "aws" {
  allowed_account_ids = ["${local.aws_account_id}"]
  region              = "${local.aws_region_id}"
}
provider "aws" {
  allowed_account_ids = ["${local.aws_account_id}"]
  alias               = "us-east-1"
  region              = "us-east-1"
}
EOF
}

# --------------------------------------------------------------------------------
# backend.tf テンプレート
# --------------------------------------------------------------------------------

remote_state {
  backend = "s3"
  config = {
    bucket  = "rcloud-poc-terraform-${local.aws_account_id}"
    encrypt = true
    key     = "tfstate/${local.System}/${local.Env}/${basename(get_terragrunt_dir())}.tfstate"
    region  = local.aws_region_id
  }
  generate = {
    path      = "backend.tf"
    if_exists = "overwrite_terragrunt"
  }
}

# --------------------------------------------------------------------------------
# グローバル属性定義
# --------------------------------------------------------------------------------

inputs = {
  account = {
    id = local.aws_account_id
  },
  hostzone = {
    id = local.hostzone
  },
  region = {
    id = local.aws_region_id
  },
  tags = {
    Name    = local.Name
    Env     = local.Env
    System  = local.System
    Account = local.Account
  },
  vpc = {
    id = local.vpc
  },
  subnet_1 = {
    id = local.subnet_1
  },
  subnet_2 = {
    id = local.subnet_2
  },
  default_kms = {
    id = local.default_kms
  },
}
