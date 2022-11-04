#!/bin/bash 
cd Terraform/application 
terraform destroy -auto-approve 
rm -rf .terraform*
rm terraform.tfstate
rm terraform.tfstate.backup
cd ..
terraform destroy -auto-approve 
rm -rf .terraform*
rm terraform.tfstate
rm terraform.tfstate.backup