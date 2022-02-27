# Firstly create a random generated password to use in secrets.

resource "random_password" "password" {
  length           = 16
  special          = true
  override_special = "!#$%&*()-_=+[]{}<>:?"
}

# Creating AWS secret for database master account (db-creds)

resource "aws_secretsmanager_secret" "db_creds" {
  name                    = "db-creds"
  recovery_window_in_days = 0
}

# Creating AWS secret versions for database master account (db-creds)

resource "aws_secretsmanager_secret_version" "creds" {
  secret_id     = aws_secretsmanager_secret.db_creds.id
  secret_string = <<EOF
   {
    "username": "${var.db_username}",
    "password": "${random_password.password.result}"
   }
EOF
}

# Importing the AWS secrets created previously using arn.

data "aws_secretsmanager_secret" "db_creds" {
  arn = aws_secretsmanager_secret.db_creds.arn
}

# Importing the AWS secret version created previously using arn.

data "aws_secretsmanager_secret_version" "creds" {
  secret_id = data.aws_secretsmanager_secret.db_creds.arn
}

# After importing the secrets storing into Locals

locals {
  db_creds = jsondecode(data.aws_secretsmanager_secret_version.creds.secret_string)
}