###################### Create role for the instance
resource "aws_iam_role" "default_role" {
  name = "default-role"

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })

}

###################### Create Instance Profile
resource "aws_iam_instance_profile" "default_profile" {
  name = "default-profile"
  role = aws_iam_role.default_role.name
}

###################### Attach SSM Core policy to role
resource "aws_iam_role_policy_attachment" "ssm_core_attach" {
  role       = aws_iam_role.default_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

###################### Attach S3 Instance Profile Access policy to role
resource "aws_iam_role_policy_attachment" "SSMInstanceProfileS3Policy_attach" {
  role       = aws_iam_role.default_role.name
  policy_arn = aws_iam_policy.SSMInstanceProfileS3Policy.arn
}

###################### Attach Secrets Manager policy to role
resource "aws_iam_role_policy_attachment" "Secrets_Manager_attach" {
  role       = aws_iam_role.default_role.name
  policy_arn = aws_iam_policy.SecretsManagerPolicy.arn
}
