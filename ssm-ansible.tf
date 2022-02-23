resource "aws_ssm_association" "ansible" {
  name = "AWS-ApplyAnsiblePlaybooks"
  association_name = "api-host"
  parameters = {
      SourceType = "S3"
      SourceInfo = "{\"path\": \"https://${module.s3_playbooks.s3_bucket_bucket_domain_name}/playbook.yml\"}"
      PlaybookFile = "playbook.yml"
  }

  targets {
    key    = "tag:Name"
    values = ["api-host"]
  }
}