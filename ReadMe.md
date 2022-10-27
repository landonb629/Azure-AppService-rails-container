# Deploying a Ruby on Rails Application to Azure App Service with a Postgresql Backend 
## Description 
This repository gives an example of how to deploy a rails docker container to an Azure App Service using a Postgresql Flexible Server backend. The docker container is built using Phusion Passenger, and the infrastructure is deployed via Terraform.
## This follow through assumes that you have knowledge in the following areas: 
    1. Microsoft Azure 
    2. Terraform 
    3. Docker 


# Infrastructure deployment 

Infrastructure will be deploy via terraform. the infrastructure required to run this application is listed below: 
1. Azure virtual network && Azure subnets 
2. Azure resource group 
3. Azure container registry 
4. Azure postgresql flexible server && database 
5. Azure app service && App service deployment slot 
6. Azure private DNS zone 


## Terraform Deployment 

There are two different Infrastructure deployments.
1. We first need to deploy the Vnet, subnets, database, RG, and container registry.
    - this deployment code is found in Terraform/main.tf 
2. After that, we need to deploy the app service, and the app service slot for the staging environment

To deploy the code 

``` cd Terraform ```

``` terraform plan ``` 

``` terraform apply -auto-approve ```



# Steps to deploy 
1. clone the repository 

2. cd to the Terraform directory 
    ``` terraform init ```
    ``` terraform apply -auto-approve ```
    wait for the infrastructure to deploy 

3. cd back to the root of the repository and build and push the initial application container 
   ``` docker build -t demorailsazure.azurecr.io/railsapp:v1.0 -f Dockerfile.prod ```
   ``` az acr login --name demorailsazure ``` 
   ``` docker push demorailsazure.azurecr.io/railsapp:v1.0 ```
   
4. cd to the Terraform/application directory
   ``` terraform init ```
   ``` terraform apply -auto-approve ```
