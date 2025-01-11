locals {
  # バケット名    [環境名]-[サービス名/システムアプリ名称]-[任意文字列] ※小文字
  bucket         = "${lower(var.tags.Env)}-${lower(var.tags.System)}-ami-bucket"
}

# --------------------------------------------------------------------------------
# Amazon S3 Contents Bucket モジュール
# @see https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket
# --------------------------------------------------------------------------------

module "contents_s3" {
  source  = "git::https://github.com/RITS-Cloud-Support/terraform-aws-resources.git//s3/complete"
  tags    = merge(var.tags, { "Name" = local.bucket})
  bucket  = local.bucket
  kms_arn = "${var.default_kms.id}"


  # --------------------------------------------------------------------------------
  # バケットポリシー
  # --------------------------------------------------------------------------------

  create_s3_bucket_policy = false
/*   path                    = "${path.module}/files/template/s3_backet_policy.json.tpl"
  vars = {
    BUCKET         = "${lower(var.tags.Env)}-${lower(var.tags.System)}-bucket-policy"
  } */

  # --------------------------------------------------------------------------------
  # バージョニング
  # --------------------------------------------------------------------------------

  versioning_status = "Enabled"
}
