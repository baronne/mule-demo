############### create EC2 instance

module "api_host" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "~> 3.1.0"

  name = "api-host"

  count                  = 1
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = var.instance_type
  subnet_id              = module.vpc[0].public_subnets[0]
  iam_instance_profile   = aws_iam_instance_profile.default_profile.name
  vpc_security_group_ids = [aws_security_group.api_host_sg.id]
  user_data              = file("userdata.sh")

  root_block_device = [
    {
      encrypted   = true
      volume_type = "gp3"
      volume_size = 10
    },
  ]

}

################# Security groups
resource "aws_security_group" "api_host_sg" {
  name   = "api-host-sg"
  vpc_id = module.vpc[0].vpc_id

  # HTTP access from VPC
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = [module.vpc[0].vpc_cidr_block]
  }

  # HTTP access from public internet
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # outbound internet access
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

