resource "aws_ssm_association" "ansible" {
  name             = "AWS-ApplyAnsiblePlaybooks"
  association_name = "api-host"
  parameters = {
    SourceType          = "S3"
    SourceInfo          = "{\"path\": \"https://${module.s3_assets.s3_bucket_bucket_domain_name}/playbook.yml\"}"
    PlaybookFile        = "playbook.yml"
    InstallDependencies = "False"
    Verbose             = "-v"
    ExtraVariables      = "Version=${filemd5("ansible/playbook.yml")}"
  }
  output_location {
    s3_bucket_name = module.s3_logging.s3_bucket_id
  }

  targets {
    key    = "tag:Name"
    values = ["api-host"]
  }

  depends_on = [
    module.s3_assets,
    aws_s3_bucket_object.playbook,
    aws_secretsmanager_secret.db_creds,
    module.aurora_mysql_serverless,
    module.aurora_mysql,
    module.rds_mysql
  ]

}