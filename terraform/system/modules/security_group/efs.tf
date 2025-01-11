locals {
  # セキュリティグループ名  [環境名]-[サービス名/アプリ名称/EC2名]-[対象区分]-SG
  efs             = "${var.tags.Env}-${var.tags.System}-EFS-SG"
}

# --------------------------------------------------------------------------------
# Maintenance EFS Security Group モジュール
# @see https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group
# --------------------------------------------------------------------------------

module "efs_sg" {
  source              = "git::https://github.com/RITS-Cloud-Support/terraform-aws-resources.git//security_group"
  tags                = merge(var.tags, { "Name" = local.efs })
  security_group_name = local.efs
  vpc_id              = data.aws_vpc.vpc.id
  ingress_rule = { # 通信要件決定後に記載
    0 = {
      description              = "ec2 to efs for sinequa"
      from_port                = 2049
      to_port                  = 2049
      protocol                 = "tcp"
      source_security_group_id = module.ec2_sg.security_group.id
    }
    1 = {
      description              = "ec2 to efs for autoscaling"
      from_port                = 2049
      to_port                  = 2049
      protocol                 = "tcp"
      source_security_group_id = module.autoscaling_sg.security_group.id
    }
  }
}
