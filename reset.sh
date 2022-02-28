#!/bin/bash

clear
echo "resetting environment..."
time ( terraform destroy --auto-approve && terraform apply --auto-approve -target=module.vpc && terraform apply --auto-approve )
