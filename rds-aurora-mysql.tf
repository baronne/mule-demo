module "aurora_mysql" {
  count = 0

  source  = "terraform-aws-modules/rds-aurora/aws"
  version = "6.1.4"

  name        = "aurora-mysql-provisioned"
  engine      = "aurora-mysql"
  engine_mode = "provisioned"

  master_username                     = local.db_creds.username
  master_password                     = local.db_creds.password
  create_random_password              = false
  iam_database_authentication_enabled = false

  database_name = var.db_name

  instances = {
    1 = {
      instance_class = var.rds_instance_class
    }
  }

  vpc_id                = module.vpc[1].vpc_id
  subnets               = module.vpc[1].private_subnets
  create_security_group = true
  allowed_cidr_blocks   = [module.vpc[0].vpc_cidr_block] #allow access from VPC1

  monitoring_interval = 60

  apply_immediately   = true
  skip_final_snapshot = true

  backup_retention_period = 1

  db_parameter_group_name         = aws_db_parameter_group.aurora_mysql.id
  db_cluster_parameter_group_name = aws_rds_cluster_parameter_group.aurora_mysql.id

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

