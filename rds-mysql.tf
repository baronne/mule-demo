module "rds_mysql" {
  count = 1

  source  = "terraform-aws-modules/rds/aws"
  version = "~> 3.0"

  identifier = "rds-mysql"

  engine            = "mysql"
  engine_version    = "8.0.28"
  instance_class    = var.rds_instance_class
  allocated_storage = 5

  name = var.db_name
  # db_name = "inventory-db" ## not in this version of the module
  username = local.db_creds.username
  password = local.db_creds.password
  port     = "3306"

  vpc_security_group_ids = [aws_security_group.db_sg.id]

  multi_az = false

  skip_final_snapshot = true
  apply_immediately   = true

  backup_retention_period = 1

  # Enhanced Monitoring - see example for details on how to create the role
  # by yourself, in case you don't want to create it automatically
  #monitoring_interval = "30"
  #monitoring_role_name = "MyRDSMonitoringRole"
  #create_monitoring_role = true

  # DB subnet group
  create_db_subnet_group = true
  subnet_ids             = module.vpc[1].private_subnets[*]

  # DB parameter group
  family = "mysql8.0"

  # DB option group
  major_engine_version = "8.0"

  # Database Deletion Protection
  deletion_protection = false



  parameters = [
    {
      name  = "character_set_client"
      value = "utf8mb4"
    },
    {
      name  = "character_set_server"
      value = "utf8mb4"
    }
  ]

  options = [
    {
      option_name = "MARIADB_AUDIT_PLUGIN"

      option_settings = [
        {
          name  = "SERVER_AUDIT_EVENTS"
          value = "CONNECT"
        },
        {
          name  = "SERVER_AUDIT_FILE_ROTATIONS"
          value = "37"
        },
      ]
    },
  ]
}


################# Security groups
resource "aws_security_group" "db_sg" {
  name   = "db_sg"
  vpc_id = module.vpc[1].vpc_id

  # MySQL access from VPC1
  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = [module.vpc[0].vpc_cidr_block]
  }

  # outbound internet access
  #   egress {
  #     from_port   = 0
  #     to_port     = 0
  #     protocol    = "-1"
  #     cidr_blocks = ["0.0.0.0/0"]
  #   }
}