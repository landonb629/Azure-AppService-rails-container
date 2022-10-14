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

