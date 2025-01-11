locals {
  # セキュリティグループ名  [環境名]-[サービス名/アプリ名称/EC2名]-[対象区分]-SG
  alb             = "${var.tags.Env}-${var.tags.System}-ALB-SG"
}

# --------------------------------------------------------------------------------
# Maintenance ALB Security Group モジュール
# @see https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group
# --------------------------------------------------------------------------------

module "alb_sg" {
  source              = "git::https://github.com/RITS-Cloud-Support/terraform-aws-resources.git//security_group"
  tags                = merge(var.tags, { "Name" = local.alb })
  security_group_name = local.alb
  vpc_id              = data.aws_vpc.vpc.id
  ingress_rule        = {
    0 = {
      description              = "HTTP Access"
      from_port                = 80
      to_port                  = 80
      protocol                 = "tcp"
      cidr_blocks              = [
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
      description              = "HTTPS Access"
      from_port                = 443
      to_port                  = 443
      protocol                 = "tcp"
      cidr_blocks              = [
        "10.0.0.0/8",
        "172.16.0.0/12",
        "192.168.0.0/16",
        "133.139.0.0/16",
        "165.96.0.0/16",
        "210.173.218.0/24",
        "151.114.0.0/16",
        "204.80.8.0/21"
      ]
    }
  }
}
