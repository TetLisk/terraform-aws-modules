locals {
  # ALB用S3 [環境名]-[ALB名]-accesslog ※小文字
  accesslog     = "${lower(var.tags.Env)}-apt-alb-accesslog"
}

# --------------------------------------------------------------------------------
# Amazon S3 Contents Bucket モジュール
# @see https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket
# --------------------------------------------------------------------------------

module "alb_access_log_s3" {
  source  = "git::https://github.com/RITS-Cloud-Support/terraform-aws-resources.git//s3/create_bucket"
  tags    = merge(var.tags, { "Name" = local.accesslog })
  bucket  = local.accesslog
  bucket_key_enabled = true
  sse_algorithm = "AES256" #SSE-S3
  kms_arn = ""


  # --------------------------------------------------------------------------------
  # バケットポリシー
  # --------------------------------------------------------------------------------

  create_s3_bucket_policy = true
  path                    = "${path.module}/files/template/alb_access_log_backet_policy.json.tpl"
  vars = {
    BUCKET         = local.accesslog
    # 以下より対象リージョンのバケットポリシーを選択する
    # https://docs.aws.amazon.com/ja_jp/elasticloadbalancing/latest/application/enable-access-logging.html#attach-bucket-policy
    IAM_ROLE_ELB   = "arn:aws:iam::582318560864:root" #東京
  }

  # --------------------------------------------------------------------------------
  # バージョニング
  # --------------------------------------------------------------------------------

  versioning_status = "Enabled"

# --------------------------------------------------------------------------------
# Amazon S3 Bucket Lifecycle Configuration 属性定義
# @see https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_lifecycle_configuration
# --------------------------------------------------------------------------------

  create_s3_bucket_lifecycle_configuration = false
  rule = [
    {
      id         = "${local.accesslog}-lifecycle_rule"
      status     = "Enabled"
      expiration =[
          {
              days                         = 180
              expired_object_delete_marker = true
          }
      ],
      noncurrent_version_expiration =[
          {
              noncurrent_days           = 1
              newer_noncurrent_versions = null
          }
      ]
    }
  ]
}
