variable "resource_group_name" {
  description = "name of the resource group in main.tf"
  type = string 
  default = ""
}

variable "location" {
  description = "location from main.tf"
  type = string 
  default = "eastus"
}

variable "deployment_name" {
  description = "name of the deployment from main.tf"
  type = string 
  default = ""
}

variable "docker_image" {
  description = "docker image name"
  type = string 
  default = "railsdemo"
}

variable "docker_image_tag" {
  description = "docker image tag"
  type = string 
  default = "v1.0"
}


