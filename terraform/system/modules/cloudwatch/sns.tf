locals {
  # sns    [環境名]-[AWSアカウント名]-keypair ※小文字
  topic        = "${var.tags.Env}-${var.tags.System}-notification"
}

module "sns_topic" {
  source     = "git::https://github.com/RITS-Cloud-Support/terraform-aws-resources.git//sns"

  name        = local.topic
  tags        = merge(var.tags, { "Name" = "${var.tags.Env}-${var.tags.System}" })
  templatefile = "${path.module}/files/sns_policy.json.tpl"
  parameters  = {
    "Resource" = "${module.sns_topic.sns_topic.arn}"
  }
  endpoint    = "kunpei.shimizu@jp.ricoh.com"
  protocol    = "email"
}
