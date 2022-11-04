# Deploying a Ruby on Rails Application to Azure App Service with a Postgresql Backend 
## Description 
This repository gives an example of how to deploy a rails docker container to an Azure App Service using a Postgresql Flexible Server backend. The docker container is built using Phusion Passenger, and the infrastructure is deployed via Terraform.
## This follow through assumes that you have knowledge in the following areas: 
    1. Microsoft Azure 
    2. Terraform 
    3. Docker 
    4. Github Actions

## What do you need to run this deployment?
1. pc that can run bash 
2. azure subscription
3. azure CLI installed 
4. Terraform installed


# Infrastructure deployment 

Infrastructure will be deploy via terraform. the infrastructure required to run this application is listed below: 
1. Azure virtual network && Azure subnets 
2. Azure resource group 
3. Azure container registry 
4. Azure container instance (Not recommended to use for production database, take a look at Postgresql flexible server)
5. Azure app service 
6. Azure private DNS zone 


## Terraform Deployment 

There are two different Infrastructure deployments.
1. We first need to deploy the Vnet, subnets, database, RG, and container registry.
    - this deployment code is found in Terraform/main.tf 

2. After that, we need to deploy the app service, and the app service slot for the staging environment

# Steps to deploy 
1. clone the repository 

2. run ./initial-deploy.sh (you may have to chmod +x locally) from your terminal and follow the prompts 


Give the application about 5-10 minutes to boot up and pull the container.

This will have deployed the rails application to azure app service, which connects to an azure container instance for postgresql database backend.

## How to check your container logs 
1. login to azure console and go to app services
2. click on your application, on the left hand side go down to "Log stream"
3. this is the log output from your application, if there are errors, they will show here



## How to deploy code changes?
- Create an azure service principal and assign it Contributor at the subscription level (this is the simple option, this does not follow principle of least privilege)

- create two secrets in github, one called ACR_PASSWORD (save the container registry password as the value), and the other is AZURE_SP_CREDENTIALS (save the entire json output that you get as the value)

1. create a new branch off of main

2. make your code change, commit the code and wait for rspec to run against your code

3. merge your code back into the main branch and that will deploy the updated code to the app service

## How to clean up your resources?
1. at the root of the repository run "./terraform-cleanup.sh"


## How to create an azure service principal 
What is an azure service principal?

```az  ```

## How can you utilize deployment slots for faster production deployments?
- create a staging azure app service slot 
- change the production deployment file in github actions to run the az cli command that will swap the staging and production container 

This method is faster then doing a deployment to the production app service directly
