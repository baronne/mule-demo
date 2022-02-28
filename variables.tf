variable "region" {
  type    = string
  default = "eu-west-1"
}

variable "aws_profile" {
  type = string
}

variable "instance_type" {
  type = string
}

variable "rds_instance_class" {
  type = string
}

variable "db_name" {
  type = string
}

variable "db_username" {
  type = string
}

variable "bucket_prefix" {
  type = string
}