variable "docker_image" {
  default = "demorailsazure.azurecr.io/railsapp"
}
variable "docker_image_tag" {
  default = "v1.0"
}
variable "deployment_name" {
  description = "name of application deployment"
  type = string 
  default = "demorailsazure"
}

variable "location" {
  description = "location for resources"
  type = string 
  default = "eastus"
}

variable "pg_version" {
  description = "version of postgres"
  type = string 
  default = "14"
}

variable "database_username" {
  description = "database username"
  type = string 
  default = "Azureapp"
}

variable "database_password" {
  description = "database password"
  type = string 
  default = "AzureAppPasswordSuperSecret"
}

variable "is_Container_Instance" {
  description = "set to true if you would like to deploy a container instance instead of postgresql flexible server"
  type = bool
  default = true  
}
