#!/bin/bash

clear
echo "AWS SSO Login Script"
echo
read -p 'Enter AWS profile [default]: ' profile
profile=${profile:-default}
read -p 'Enter AWS region to use [eu-west-1]: ' region
region=${region:-eu-west-1}
aws sso login --profile $profile --region $region