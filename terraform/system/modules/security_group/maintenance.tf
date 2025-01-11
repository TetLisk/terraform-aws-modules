locals {
  # セキュリティグループ名  [環境名]-[サービス名/アプリ名称/EC2名]-[対象区分]-SG
  asg = "${var.tags.Env}-${var.tags.System}-AGS-SG"
  ec2 = "${var.tags.Env}-${var.tags.System}-EC2-SG"
}

# --------------------------------------------------------------------------------
# Maintenance EC2 Instance Security Group モジュール
# @see https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group
# --------------------------------------------------------------------------------

module "autoscaling_sg" {
  source              = "git::https://github.com/RITS-Cloud-Support/terraform-aws-resources.git//security_group"
  tags                = merge(var.tags, { "Name" = local.asg })
  security_group_name = local.asg
  vpc_id              = data.aws_vpc.vpc.id
  ingress_rule = { # 通信要件決定後に記載
    0 = {
      description              = "AMI remote"
      from_port                = 0
      to_port                  = 0
      protocol                 = "-1"

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
    }
    1 = {
      description              = "alb to ec2"
      from_port                = 80
      to_port                  = 80
      protocol                 = "tcp"
      source_security_group_id = module.alb_sg.security_group.id
    }
    2 = {
      description              = "alb to ec2"
      from_port                = 443
      to_port                  = 443
      protocol                 = "tcp"
      source_security_group_id = module.alb_sg.security_group.id
    }
  }
}

module "ec2_sg" {
  source              = "git::https://github.com/RITS-Cloud-Support/terraform-aws-resources.git//security_group"
  tags                = merge(var.tags, { "Name" = local.ec2 })
  security_group_name = local.ec2
  vpc_id              = data.aws_vpc.vpc.id
  ingress_rule = { # 通信要件決定後に記載
    0 = {
      description              = "ec2 remote"
      from_port                = 0
      to_port                  = 0
      protocol                 = "-1"

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
    }
    1 = {
      description              = "alb to ec2"
      from_port                = 80
      to_port                  = 80
      protocol                 = "tcp"
      source_security_group_id = module.alb_sg.security_group.id
    }
  }
}
