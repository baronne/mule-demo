################# Create S3 bucket to store ansible playbooks
module "s3_playbooks" {
  source = "terraform-aws-modules/s3-bucket/aws"
  version = "2.14.1"

  bucket = "bmdev-playbooks"
  acl    = "private"

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true

}

###################### Create S3 bucket access policy
resource "aws_iam_policy" "SSMInstanceProfileS3Policy" {
  name = "SSMInstanceProfileS3Policy"
  policy = jsonencode({
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid" : "ListObjectsInBucket",
            "Effect" : "Allow",
            "Action" : [
            "s3:ListBucket"
            ],
            "Resource" : [
            module.s3_playbooks.s3_bucket_arn
        ]
        },
        {
            "Effect": "Allow",
            "Action": [
                "s3:GetObject",
                "s3:PutObject",
                "s3:PutObjectAcl", 
                "s3:GetEncryptionConfiguration" 
            ],
            "Resource": [
                "${module.s3_playbooks.s3_bucket_arn}/*",
                "${module.s3_playbooks.s3_bucket_arn}" 
            ]
        }
    ]
})
}

#################################################### UPLOAD Playbooks
resource "aws_s3_bucket_object" "playbooks" {
  for_each = fileset("ansible/", "**")
  bucket   = module.s3_playbooks.s3_bucket_id
  key      = "/${each.value}"
  source   = "ansible/${each.value}"
  source_hash = filemd5("ansible/${each.value}")
}