locals {
  # ELB                 [環境名]-[サービス名/システムアプリ名称]-[製品名]-[ELB区分] ※小文字
  # ターゲットグループ   [環境名]-[サービス名/システムアプリ名称]-[製品名]-tg-[ポート番号] ※小文字
  alb        = "${lower(var.tags.Env)}-${lower(var.tags.System)}-apt-alb"
  target_ec2 = "${lower(var.tags.Env)}-${lower(var.tags.System)}-apt-tg-80"
  target_asg = "${lower(var.tags.Env)}-${lower(var.tags.System)}-apt-asg-tg-80"
  target_8080  = "${lower(var.tags.Env)}-${lower(var.tags.System)}-apt-tg-8080"
}

# --------------------------------------------------------------------------------
# Maintenance ALB モジュール
# @see https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/alb/
# --------------------------------------------------------------------------------

module "alb" {
  source                           = "git::https://github.com/RITS-Cloud-Support/terraform-aws-resources.git//alb/complete"
# --------------------------------------------------------------------------------
# Application Load Balancer リソース定義
# @see https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb
# --------------------------------------------------------------------------------
  tags                             = merge(var.tags, { "Name" = local.alb })
  alb_name                         = local.alb
  drop_invalid_header_fields       = true #無効なHTTPリクエストヘッダの削除
  enable_cross_zone_load_balancing = true
  enable_deletion_protection       = false #APIによるALB削除の保護設定
  enable_http2                     = true
  idle_timeout                     = 60
  internal                         = true
  ip_address_type                  = "ipv4"
  load_balancer_type               = "application"
  security_groups                  = var.vpc_security_group_ids
  subnets                          = [ "${data.aws_subnet.subnet_1.id}", "${data.aws_subnet.subnet_2.id}" ]
  access_logs                      = [
                                       {
                                        bucket  = module.alb_access_log_s3.s3_bucket.id
                                        enabled = true
                                        prefix  = null
                                       }
                                     ]
# --------------------------------------------------------------------------------
# Application Load Balancer Target Group リソース定義
# @see https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_target_group
# --------------------------------------------------------------------------------
  target_group_name                  = local.target_ec2
  deregistration_delay               = 300
  lambda_multi_value_headers_enabled = false
  target_port                        = 80
  target_protocol                    = "HTTP"
  protocol_version                   = "HTTP1"
  proxy_protocol_v2                  = false #X-Forwarded-forと同等の機能
  slow_start                         = 0
  target_type                        = "instance"
  vpc_id                             = data.aws_vpc.vpc.id
  //health_check
  health_check_enabled             = true
  health_check_healthy_threshold   = 3
  health_check_interval            = 30
  health_check_matcher             = "200"
  health_check_path                = "/"
  health_check_port                = "traffic-port"
  health_check_protocol            = "HTTP"
  health_check_timeout             = 6
  health_check_unhealthy_threshold = 3
  //stickiness
  stickiness_cookie_duration = 86400
  stickiness_enabled         = true
  stickiness_type            = "lb_cookie"
# --------------------------------------------------------------------------------
# Application Load Balancer Listener リソース定義
# @see https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_listener
# --------------------------------------------------------------------------------
  certificate_arn     = null
  listener_port       = "80"
  listener_protocol   = "HTTP"
  ssl_policy          = null
  default_action_type = "forward"
# --------------------------------------------------------------------------------
# Application Load Balancer Listener Rule リソース定義
# @see https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_listener_rule
# --------------------------------------------------------------------------------
  action_type                    = "forward"
  create_alb_listener_rule       = false
  listener_rule_condition_values = ["/"]
  listener_rule_priority         = 50000
# --------------------------------------------------------------------------------
# Application Load Balancer Target Group Attachment 属性定義
# @see https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_target_group_attachment
# --------------------------------------------------------------------------------
  target_id                      = var.ec2_ids
}
# --------------------------------------------------------------------------------
# 以下ec2用リスナールール
# --------------------------------------------------------------------------------
module "ec2-http-listener-rule" {
  source                         = "git::https://github.com/RITS-Cloud-Support/terraform-aws-resources.git//alb/listener_rule"
# --------------------------------------------------------------------------------
# Application Load Balancer Listener Rule リソース定義
# @see https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_listener_rule
# --------------------------------------------------------------------------------
  listener_arn                   = module.alb.alb_listener.arn
  priority                       = 10
  action_target_group_arn        = module.alb.alb_target_group.arn
  action_type                  = "redirect"
  redirect = [
    {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  ]
  condition_host_header_values = ["inner-test.support.rcloud.ricoh.com"]
}



# --------------------------------------------------------------------------------
# Application Load Balancer Target Group リソース定義
# @see https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_target_group
# 以下AutoScaling用ターゲットグループ
# --------------------------------------------------------------------------------
module "autoscaling_target_group" {
  source                             = "git::https://github.com/RITS-Cloud-Support/terraform-aws-resources.git//alb/target_group/"
  tags                               = merge(var.tags, { "Name" = local.target_asg })
  name                               = local.target_asg
  deregistration_delay               = 30
  lambda_multi_value_headers_enabled = false
  port                               = 80
  protocol                           = "HTTP"
  proxy_protocol_v2                  = false #X-Forwarded-forと同等の機能
  slow_start                         = 0
  target_type                        = "instance"
  vpc_id                             = data.aws_vpc.vpc.id
  //health_check
  health_check_enabled             = true
  health_check_healthy_threshold   = 3
  health_check_interval            = 30
  health_check_matcher             = "200"
  health_check_path                = "/"
  health_check_port                = "traffic-port"
  health_check_protocol            = "HTTP"
  health_check_timeout             = 6
  health_check_unhealthy_threshold = 3
  //stickiness
  stickiness_cookie_duration = 86400
  stickiness_enabled         = true
  stickiness_type            = "lb_cookie"
}
# --------------------------------------------------------------------------------
# 以下AutoScaling用リスナールール
# --------------------------------------------------------------------------------
module "autoscaling-http-listener-rule" {
  source                         = "git::https://github.com/RITS-Cloud-Support/terraform-aws-resources.git//alb/listener_rule"
# --------------------------------------------------------------------------------
# Application Load Balancer Listener Rule リソース定義
# @see https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_listener_rule
# --------------------------------------------------------------------------------
  listener_arn                   = module.alb.alb_listener.arn
  priority                       = 30
  action_target_group_arn        = module.autoscaling_target_group.alb_target_group.arn
  action_type                  = "redirect"
  redirect = [
    {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  ]
  condition_path_pattern_values  = ["/index.html"]
  condition_host_header_values = ["asg.inner-test.support.rcloud.ricoh.com"]
}



# --------------------------------------------------------------------------------
# Application Load Balancer Target Group リソース定義
# @see https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_target_group
# 以下8080番用ターゲットグループ
# --------------------------------------------------------------------------------
module "p8080_target_group" {
  source                             = "git::https://github.com/RITS-Cloud-Support/terraform-aws-resources.git//alb/target_group/"
  tags                               = merge(var.tags, { "Name" = local.target_8080 })
  name                               = local.target_8080
  deregistration_delay               = 30
  lambda_multi_value_headers_enabled = false
  port                               = 8080
  protocol                           = "HTTP"
  proxy_protocol_v2                  = false #X-Forwarded-forと同等の機能
  slow_start                         = 0
  target_type                        = "instance"
  vpc_id                             = data.aws_vpc.vpc.id
  //health_check
  health_check_enabled             = true
  health_check_healthy_threshold   = 3
  health_check_interval            = 30
  health_check_matcher             = "200"
  health_check_path                = "/"
  health_check_port                = "traffic-port"
  health_check_protocol            = "HTTP"
  health_check_timeout             = 6
  health_check_unhealthy_threshold = 3
  //stickiness
  stickiness_cookie_duration = 86400
  stickiness_enabled         = true
  stickiness_type            = "lb_cookie"
}
module "p8080_target_group_attachment" {
  source           = "git::https://github.com/RITS-Cloud-Support/terraform-aws-resources.git//alb/target_group_attachment/"
  target_group_arn = module.p8080_target_group.alb_target_group.arn
  target_id        = var.ec2_ids
  port             = 8080
}
# --------------------------------------------------------------------------------
# 以下81用リスナールール
# --------------------------------------------------------------------------------
module "p8080-http-listener-rule" {
  source                         = "git::https://github.com/RITS-Cloud-Support/terraform-aws-resources.git//alb/listener_rule"
# --------------------------------------------------------------------------------
# Application Load Balancer Listener Rule リソース定義
# @see https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_listener_rule
# --------------------------------------------------------------------------------
  listener_arn                   = module.alb.alb_listener.arn
  priority                       = 50
  action_target_group_arn        = module.p8080_target_group.alb_target_group.arn
  action_type                  = "redirect"
  redirect = [
    {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  ]
  condition_host_header_values = ["8080.inner-test.support.rcloud.ricoh.com"]
}



# --------------------------------------------------------------------------------
# 以下HTTPSリスナー作成用
# ※Completeでは複数のリスナーを作成できないため
# --------------------------------------------------------------------------------
module "alb-https-listener" {
  source                           = "git::https://github.com/RITS-Cloud-Support/terraform-aws-resources.git//alb/listener"
# --------------------------------------------------------------------------------
# Application Load Balancer Listener リソース定義
# @see https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_listener
# --------------------------------------------------------------------------------
  certificate_arn     = "arn:aws:acm:ap-northeast-1:421340346768:certificate/3a91cbad-1a4a-4684-90ef-74d2a36f0e1f" #acmのarnを記載
  load_balancer_arn   = module.alb.alb.arn
  port       = "443"
  protocol   = "HTTPS"
  ssl_policy          = "ELBSecurityPolicy-2016-08"
  default_action      = [
    {
      type             = "forward"
      target_group_arn = module.alb.alb_target_group.arn
      authenticate_cognito = []
      fixed_response = []
    }
  ]
}
module "ec2-https-listener-rule" {
  source                       = "git::https://github.com/RITS-Cloud-Support/terraform-aws-resources.git//alb/listener_rule"
# --------------------------------------------------------------------------------
# Application Load Balancer Listener Rule リソース定義
# @see https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_listener_rule
# ---------------DDD-----------------------------------------------------------------
  listener_arn                 = module.alb-https-listener.alb_listener.arn
  priority                     = 20
  action_target_group_arn      = module.alb.alb_target_group.arn
  action_type                    = "forward"
  condition_host_header_values = ["inner-test.support.rcloud.ricoh.com"]
}
module "autoscaling-https-listener-rule" {
  source                         = "git::https://github.com/RITS-Cloud-Support/terraform-aws-resources.git//alb/listener_rule"
# --------------------------------------------------------------------------------
# Application Load Balancer Listener Rule リソース定義
# @see https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_listener_rule
# --------------------------------------------------------------------------------
  listener_arn                 = module.alb-https-listener.alb_listener.arn
  priority                     = 40
  action_target_group_arn      = module.autoscaling_target_group.alb_target_group.arn
  action_type                    = "forward"
  condition_host_header_values   = ["asg.inner-test.support.rcloud.ricoh.com"]
}
module "p8080-https-listener-rule" {
  source                         = "git::https://github.com/RITS-Cloud-Support/terraform-aws-resources.git//alb/listener_rule"
# --------------------------------------------------------------------------------
# Application Load Balancer Listener Rule リソース定義
# @see https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_listener_rule
# --------------------------------------------------------------------------------
  listener_arn                 = module.alb-https-listener.alb_listener.arn
  priority                     = 60
  action_target_group_arn      = module.p8080_target_group.alb_target_group.arn
  action_type                    = "forward"
  condition_host_header_values   = ["8080.inner-test.support.rcloud.ricoh.com"]
}
