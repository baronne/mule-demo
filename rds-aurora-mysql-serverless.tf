module "aurora_mysql_serverless" {
  count = 1

  source  = "terraform-aws-modules/rds-aurora/aws"
  version = "6.1.4"

  name        = "db"
  engine      = "aurora-mysql"
  engine_mode = "serverless"

  master_username                     = local.db_creds.username
  master_password                     = local.db_creds.password
  create_random_password              = false
  iam_database_authentication_enabled = false

  database_name = var.db_name

  vpc_id                = module.vpc[1].vpc_id
  subnets               = module.vpc[1].private_subnets
  create_security_group = true
  allowed_cidr_blocks   = [module.vpc[0].vpc_cidr_block] # allow access from VPC1

  monitoring_interval = 60

  apply_immediately   = true
  skip_final_snapshot = true

  backup_retention_period = 1

  db_parameter_group_name         = aws_db_parameter_group.aurora_mysql_serverless.id
  db_cluster_parameter_group_name = aws_rds_cluster_parameter_group.aurora_mysql_serverless.id
  # enabled_cloudwatch_logs_exports = # NOT SUPPORTED

  scaling_configuration = {
    auto_pause               = true
    min_capacity             = 1
    max_capacity             = 2
    seconds_until_auto_pause = 300
    timeout_action           = "ForceApplyCapacityChange"
  }
}

resource "aws_db_parameter_group" "aurora_mysql_serverless" {
  name        = "inventory-aurora-db-serverless-mysql-parameter-group"
  family      = "aurora-mysql5.7"
  description = "inventory-aurora-db-serverless-mysql-parameter-group"
}

resource "aws_rds_cluster_parameter_group" "aurora_mysql_serverless" {
  name        = "inventory-aurora-serverless-mysql-cluster-parameter-group"
  family      = "aurora-mysql5.7"
  description = "inventory-aurora-serverless-mysql-cluster-parameter-group"
}

