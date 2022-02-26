###################### Create Secrets Manager Policy
resource "aws_iam_policy" "SecretsManagerPolicy" {
  name = "SecretsManagerPolicy"
  policy = jsonencode({
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "secretsmanager:GetResourcePolicy",
                "secretsmanager:GetSecretValue",
                "secretsmanager:DescribeSecret",
                "secretsmanager:ListSecretVersionIds"
            ],
            "Resource": [
                aws_secretsmanager_secret.db_creds.arn
            ]
        },
        {
            "Effect": "Allow",
            "Action": "secretsmanager:ListSecrets",
            "Resource": "*"
        }
    ]
  })
}


###################### Create S3 bucket access policy
resource "aws_iam_policy" "SSMInstanceProfileS3Policy" {
  name = "SSMInstanceProfileS3Policy"
  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Sid" : "ListObjectsInBucket",
        "Effect" : "Allow",
        "Action" : [
          "s3:ListBucket"
        ],
        "Resource" : [
          module.s3_playbooks.s3_bucket_arn,
          module.s3_logging.s3_bucket_arn
        ]
      },
      {
        "Effect" : "Allow",
        "Action" : [
          "s3:GetObject",
          "s3:PutObject",
          "s3:PutObjectAcl",
          "s3:GetEncryptionConfiguration"
        ],
        "Resource" : [
          "${module.s3_playbooks.s3_bucket_arn}/*",
          "${module.s3_playbooks.s3_bucket_arn}",
          "${module.s3_logging.s3_bucket_arn}/*",
          "${module.s3_logging.s3_bucket_arn}"
        ]
      }
    ]
  })
}