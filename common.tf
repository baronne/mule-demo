# Grab the latest Amazon Linux 2 AMI
data "aws_ami" "amazon-linux" {
  most_recent = true
  owners      = ["amazon"]
  filter {
    name   = "name"
    values = ["amzn2-ami-kernel-5.10-hvm*"]
  }
  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

# Grab the latest Ubuntu 20.04 AMI
data "aws_ami" "ubuntu" {
    most_recent = true
    owners = ["099720109477"]
    filter {
        name   = "name"
        values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
    }
    filter {
        name = "virtualization-type"
        values = ["hvm"]
    }
}



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

###################### Attach S3 Access policy to role
resource "aws_iam_role_policy_attachment" "s3_policy_attach" {
  role       = aws_iam_role.default_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3ReadOnlyAccess"
}

###################### Attach S3 Instance Profile Access policy to role
# resource "aws_iam_role_policy_attachment" "SSMInstanceProfileS3Policy_attach" {
#   role       = aws_iam_role.default_role.name
#   policy_arn = aws_iam_policy.SSMInstanceProfileS3Policy.arn
# }
