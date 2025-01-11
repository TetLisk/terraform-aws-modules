locals {
  # セキュリティグループ名  [環境名]-[サービス名/アプリ名称/EC2名]-[対象区分]-SG
  rds             = "${var.tags.Env}-${var.tags.System}-RDS-SG"
}

# --------------------------------------------------------------------------------
# Amazon RDS Security Group モジュール
# @see https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group
# --------------------------------------------------------------------------------

module "rds_sg" {
  source              = "git::https://github.com/RITS-Cloud-Support/terraform-aws-resources.git//security_group"
  tags                = merge(var.tags, { "Name" = local.rds })
  security_group_name = local.rds
  vpc_id              = data.aws_vpc.vpc.id
  ingress_rule = {  # 通信要件決定後に記載
    0 = {
      description              = "system maintenance"
      from_port                = 1521
      to_port                  = 1521
      protocol                 = "tcp"
      cidr_blocks = [
        "10.0.0.0/8",
        "172.16.0.0/12",
        "192.168.0.0/16",
        "133.139.0.0/16",
        "165.96.0.0/16",
        "210.173.218.0/24",
        "151.114.0.0/16",
        "204.80.8.0/21"
      ]
    },
    1 = {
      description              = "db_maintenance from autoscaling"
      from_port                = 1521
      to_port                  = 1521
      protocol                 = "tcp"
      source_security_group_id = module.autoscaling_sg.security_group.id
    }
  }
}
