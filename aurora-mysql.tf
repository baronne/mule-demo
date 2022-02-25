module "aurora_db" {
  source = "terraform-aws-modules/rds-aurora/aws"

  version = "6.1.4"

  name              = "inventory-db"
  engine            = "aurora-mysql"
  engine_mode       = "serverless"
  storage_encrypted = true

  vpc_id                = module.vpc[1].vpc_id
  subnets               = module.vpc[1].private_subnets
  create_security_group = true
  allowed_cidr_blocks   = [module.vpc[0].vpc_cidr_block]

  monitoring_interval = 60

  apply_immediately   = true
  skip_final_snapshot = true

  backup_retention_period = 1

  db_parameter_group_name         = aws_db_parameter_group.aurora_mysql.id
  db_cluster_parameter_group_name = aws_rds_cluster_parameter_group.aurora_mysql.id
  # enabled_cloudwatch_logs_exports = # NOT SUPPORTED

  scaling_configuration = {
    auto_pause               = true
    min_capacity             = 1
    max_capacity             = 2
    seconds_until_auto_pause = 300
    timeout_action           = "ForceApplyCapacityChange"
  }
}

resource "aws_db_parameter_group" "aurora_mysql" {
  name        = "inventory-aurora-db-mysql-parameter-group"
  family      = "aurora-mysql5.7"
  description = "inventory-aurora-db-mysql-parameter-group"
}

resource "aws_rds_cluster_parameter_group" "aurora_mysql" {
  name        = "inventory-aurora-mysql-cluster-parameter-group"
  family      = "aurora-mysql5.7"
  description = "inventory-aurora-mysql-cluster-parameter-group"
}

