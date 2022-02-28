#!/bin/bash

clear
echo "building environment..."
time ( terraform apply --auto-approve -target=module.vpc && terraform apply --auto-approve )
