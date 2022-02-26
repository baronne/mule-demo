#!/bin/bash

Ouput all logs
exec > >(tee /var/log/user-data.log|logger -t user-data-extra -s 2>/dev/console) 2>&1

# Amazon Linux:
# sudo amazon-linux-extras install epel
# sudo yum update -y
# sudo yum install ansible -y
# sudo ansible-galaxy collection install community.general

sudo apt update -y
sudo apt install ansible -y
sudo ansible-galaxy collection install community.general
