################# Create S3 bucket to store ansible playbooks
module "s3_playbooks" {
  source  = "terraform-aws-modules/s3-bucket/aws"
  version = "2.14.1"

  bucket = "bmdev-playbooks"
  acl    = "private"

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true

}

################# Create S3 bucket for logging
module "s3_logging" {
  source  = "terraform-aws-modules/s3-bucket/aws"
  version = "2.14.1"

  bucket = "bmdev-logging"
  acl    = "private"

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true

  force_destroy = true

}


#################################################### Upload Ansible Playbook
data "template_file" "playbook" {
  template = file("ansible/playbook.yml")
  vars = {
    rds_endpoint = module.aurora_mysql_serverless[0].cluster_endpoint
    db_name      = var.db_name
    db_username  = var.db_username
    region       = var.region
  }
}

resource "aws_s3_bucket_object" "playbook" {
  bucket      = module.s3_playbooks.s3_bucket_id
  key         = "playbook.yml"
  content     = data.template_file.playbook.rendered
  source_hash = filemd5("ansible/playbook.yml")
}