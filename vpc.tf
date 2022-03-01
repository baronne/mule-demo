module "vpc" {
  source = "terraform-aws-modules/vpc/aws"
  count  = 2
  name   = "vpc${count.index + 1}"
  cidr   = "10.${count.index + 1}.0.0/16"

  azs             = ["${var.region}a", "${var.region}b"]
  private_subnets = ["10.${count.index + 1}.1.0/24", "10.${count.index + 1}.2.0/24"]
  public_subnets  = ["10.${count.index + 1}.101.0/24"]

  enable_nat_gateway = false
  single_nat_gateway = true

  enable_dns_hostnames = true


}