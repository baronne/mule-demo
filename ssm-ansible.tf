resource "aws_ssm_association" "ansible" {
  name             = "AWS-ApplyAnsiblePlaybooks"
  association_name = "api-host"
  parameters = {
    SourceType   = "S3"
    SourceInfo   = "{\"path\": \"https://${module.s3_playbooks.s3_bucket_bucket_domain_name}/playbook.yml\"}"
    PlaybookFile = "playbook.yml"
    InstallDependencies = "True"
    Verbose = "-vvvv"
  }
  output_location {
    s3_bucket_name = module.s3_logging.s3_bucket_id
  }

  targets {
    key    = "tag:Name"
    values = ["api-host"]
  }

  depends_on = [
    module.s3_playbooks
  ]

  
}