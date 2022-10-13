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
  default = "rails"
}

variable "database_password" {
  description = "database password"
  type = string 
  default = ":EIWPVIEUPuboghieoinlkj"
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
