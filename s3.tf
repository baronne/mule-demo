################# Create S3 bucket to store ansible playbooks, and other config assets
module "s3_assets" {
  source  = "terraform-aws-modules/s3-bucket/aws"
  version = "2.14.1"

  bucket = "${var.bucket_prefix}-assets"
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

  bucket = "${var.bucket_prefix}-logging"
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
    #rds_endpoint = module.aurora_mysql[0].cluster_endpoint
    #rds_endpoint = module.aurora_mysql_serverless[0].cluster_endpoint
    rds_endpoint = module.rds_mysql[0].db_instance_address
    db_name      = var.db_name
    db_username  = var.db_username
    region       = var.region
  }
}

resource "aws_s3_bucket_object" "playbook" {
  bucket      = module.s3_assets.s3_bucket_id
  key         = "playbook.yml"
  content     = data.template_file.playbook.rendered
  source_hash = filemd5("ansible/playbook.yml")
}