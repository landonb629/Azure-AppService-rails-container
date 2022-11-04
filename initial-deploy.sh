#!/bin/bash 
set -e 
echo 'please login to azure cli...'
az login 

echo 'Do you have multiple azure subscriptions? y/n'
read azureSubs
if [[ $azureSubs == 'y' || $azureSubs == 'Y' ]]
then 
    echo 'Please provide the subscription ID'
    read subID
    az account set --subscription $subID
elif [[ $azureSubs == 'n' || $azureSubs == 'N' ]]
then 
    break
else 
    echo 'Incorrect Input'
    exit
fi

echo 'Building initial docker container...'
cd Azureapp
docker build -t demorailsazure.azurecr.io/railsapp:v1.0 -f Dockerfile.prod .
cd ..

echo 'Deploying Infrastructure associated with application...'
cd Terraform 
terraform init
terraform apply -auto-approve 

echo 'Get the azure registry password from the console and replace the value in Terraform/application/main.tf, once done, type yes'
read userInput

if [[ $userInput == 'yes' || $userInput == "Yes" ]]
then 
    cd ..
    az acr login --name demorailsazure
    docker push demorailsazure.azurecr.io/railsapp:v1.0 
    cd Terraform/application
    terraform init
    terraform apply -auto-approve
else 
    echo 'error, incorrect input'
fi









