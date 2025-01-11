locals {
  # IAMグループ    [環境名]-[AWSアカウント名]-[任意文字列] ※小文字
  # IAMロール      [環境名]-[AWSアカウント名/インスタンス名/アプリ名]-[サービス名]role ※小文字
  # IAMポリシー    [環境名]-[サービス名]-[任意文字列] ※小文字
  role           = "${lower(var.tags.Env)}-${lower(var.tags.Account)}-ec2role"
  default_policy = "${lower(var.tags.Env)}-${lower(var.tags.Account)}-ec2-describe-tags"
  ssm_policy     = "${lower(var.tags.Env)}-${lower(var.tags.Account)}-ec2-ssm"
}
# --------------------------------------------------------------------------------
# Maintenance EC2 Instance IAM モジュール
# @see https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group
# --------------------------------------------------------------------------------

module "maintenance_iam" {
  source                      = "git::https://github.com/RITS-Cloud-Support/terraform-aws-resources.git//iam/complete"
  tags                        = merge(var.tags, { "Name" = local.role})
  role_name                   = local.role
  create_iam_instance_profile = true
  profile_name                = "${lower(var.tags.Env)}-${lower(var.tags.System)}-ec2profile"
  role_path                   = "${path.module}/files/template/default_iam_assume_role.json.tpl"
  role_vars                   = {
                                  SERVICE = "ec2.amazonaws.com"
                                }

  policy_path                 = "${path.module}/files/template/EC2Describe_tags.json.tpl"
  policy_name                 = local.default_policy
}

module "ssm_policy" {
  source                            = "git::https://github.com/RITS-Cloud-Support/terraform-aws-resources.git//iam/policy"
  tags                              = merge(var.tags, { "Name" = local.ssm_policy})
  name                              = local.ssm_policy
  policy_document                   = "${path.module}/files/template/AmazonSSMManagedInstanceCore.json.tpl"
  create_iam_role_policy_attachment = true //ssmを有効にする場合のみtrue
  role                              = module.maintenance_iam.iam_role.name
}
