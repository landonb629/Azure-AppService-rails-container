#!/bin/bash 
cd Terraform/application 
terraform destroy -auto-approve 
rm -rf .terraform*
cd ..
terraform destroy -auto-approve 
rm -rf .terraform*