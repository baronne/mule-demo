# Mulesoft Inventory API Demo

This is a demo to automate and build a Mulesoft API. The terraform code will deploy a basic architecture of two VPCs (peered). 

VPC1 is where the Mule Enterprise Standalone Runtime server is deployed. \
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
- Ensure your AWS CLI profile is configured appropriately (access keys or SSO). For example, to configure an SSO profile, run the command: ```aws configure sso --profile dev```
- You can use the ./build.sh command to build the environment - this script just does a terraform apply in two stages. Firstly to provision the VPC, and then the remainder of the infrastructure/services.

Note: there are alternate configurations for aurora mysql, but disabled. You can make use of these if you wish but there were compatibility issues with the inventory api project and the version aurora serverless that was available the time this was developed. 

## Configuring and deploying the demo API
### Registering the runtime server with AnyPoint Platform
- Sign up for an Anpoint Platform free trial (if you haven't got an account already)
- Log in to the platform and go to the "Runtime Manager"
- Add a server (Servers > Add Server)
- Give it a name (eg. api-host), and copy the supplied command to execute on your EC2 instance deployed previously
- Connect to your instance (use SSM Session Manager) via the AWS Console
- At the CLI:
  ``` bash
  cd /opt/mule-enterprise-standalone-4.4.0/bin
  sudo [paste command supplied]
  sudo ./mule restart
  ```
- The AnyPoint Platform should display the server as connected

### Deploying the API
- Download AnyPoint Studio (again, need to sign up)
- Download/Clone the demo API provided ([here](https://github.com/gonzalo-camino/fssm-inventory-api))
- Open the project in AnyPoint Studio
- Modify the details in the src/main/resources/conf/configuration.yaml file, supply the details from your provisioned infrastructure (mysql host, port, user, password, database), and save the file. 
- Export the project as an AnyPoint Project, save the exported .jar somewhere convenient. 
- Go to AnyPoint Platform > Runtime Manager
- Deploy Application (Applications > Deploy application)
- Give it a name (eg. Inventory-API)
- Select your host from the Deployment Target
- Application File > Choose File > Upload the previously exported .jar
- Connect to the API Console, http://<ec2_instance_public_ip>:8081/console
- Test the API and you should retrieve results from the DB. 

## License
[MIT](https://choosealicense.com/licenses/mit/)