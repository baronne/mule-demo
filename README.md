# Mulesoft Inventory API Demo

This is a demo to automate and build a Mulesoft API. The terraform code will deploy a basic architecture of two VPCs (peered). 

VPC1 is where the Mule Enterprise Standalone Runtime server is deployed. 

VPC2 is where the RDS MySQL server is deployed.

Additionally, terraform will configure AWS Systems Manager to run an Ansible playbook to configure the server.

Manual steps are required to configure the Mulesoft API server using AnyPoint Studio and the AnyPoint Platform.

## Deploying the infrastructure
- Clone the repo
- Create a terraform.tfvars file and configure the required variables, for example:
  ```
  aws_profile        = "dev"
  region             = "eu-west-1"
  instance_type      = "t3.medium"
  rds_instance_class = "db.t3.micro"
  db_name            = "inventorydb"
  db_username        = "admin"
  bucket_prefix      = "mydev"
  ```
- Ensure your AWS CLI profile is configured appropriately (access keys or SSO)
  - For example, to configure an SSO profile, run the command:
    ```aws configure sso --profile dev```
- You can use the ./build.sh command to build the environment - this script just does a terraform apply in two stages. Firstly to provision the VPC, and then the remainder of the infrastructure/services.

## Configuring and deploying the demo API and deploying