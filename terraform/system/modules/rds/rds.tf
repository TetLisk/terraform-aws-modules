locals {
  # RDS               [環境名]-[サービス名/システムアプリ名称]-db ※小文字
  # オプショングループ  [環境名]-[サービス名/システムアプリ名称]-oracle19c-opg※小文字
  rds        = "${lower(var.tags.Env)}-${lower(var.tags.System)}-db"
  rds_option = "${lower(var.tags.Env)}-${lower(var.tags.System)}-oracle19c-opg"
}

# --------------------------------------------------------------------------------
# Amazon RDS for SQLServer 構築 RDS Option group モジュール
# --------------------------------------------------------------------------------

module "rds_option_group" {
  source               = "git::https://github.com/RITS-Cloud-Support/terraform-aws-resources.git//rds/db_option_group"
  tags                 = merge(var.tags, { "Name" = local.rds_option})
  option_group_name    = local.rds_option
  engine_name          = "oracle-se2"
  major_engine_version = "19"
  options = [
    {
      option_name     = "Timezone"
      option_settings = [
        {
          name          = "TIME_ZONE"
          value         = "Asia/Tokyo"
        }
      ]
    }
  ]
}

module "rds" {
  source = "git::https://github.com/RITS-Cloud-Support/terraform-aws-resources.git//rds/db_instance"
  # --------------------------------------------------------------------------------
  # Amazon RDS Subnet Group モジュール
  # @see https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/db_subnet_group
  # --------------------------------------------------------------------------------
  subnet_group_name               = "${local.rds}-subnet"
  subnet_ids                      = [ "${data.aws_subnet.subnet_1.id}", "${data.aws_subnet.subnet_2.id}" ]

  # --------------------------------------------------------------------------------
  # Amazon RDS DB Instance モジュール
  # @see https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/db_subnet_group
  # --------------------------------------------------------------------------------
  tags                            = merge(var.tags, { "Name" = local.rds})
  identifier                      = local.rds
  option_group_name               = local.rds_option
  apply_immediately               = true
  engine                          = "oracle-se2"
  engine_version                  = "19.0.0.0.ru-2024-07.rur-2024-07.r1"
  instance_class                  = "db.r6i.large"
  allocated_storage               = 100
  storage_type                    = "gp3"
  publicly_accessible             = false
  security_group_ids              = var.vpc_security_group_ids
  database_name                   = var.database_name
  database_user                   = var.username //tfvarsで定義
  database_password               = var.password //tfvarsで定義
  backup_retention_period         = 7
  backup_window                   = "16:00-18:00"
  maintenance_window              = "fri:18:00-fri:20:00"
  license_model                   = "license-included"
  copy_tags_to_snapshot           = true
  database_port                   = 1521
  skip_final_snapshot             = true
  storage_encrypted               = true
  kms_key_arn                     = "${var.default_kms.id}"
  enabled_cloudwatch_logs_exports = ["alert", "audit"]
  iops                            = null #oracleで200GB以上の場合は12,000
  character_set_name              = "AL32UTF8"
  nchar_character_set_name        = "AL16UTF16"
  ca_cert_identifier              = "rds-ca-rsa2048-g1"
  multi_az                        = var.tags.Env == "P" ? "true" : "false" //prdの場合のみmulti AZ

  depends_on = [module.rds_option_group]
}
