####################
## resource group ##
####################
resource "azurerm_resource_group" "rg" {
  name = var.deployment_name
  location = var.location
}

########################
## VNET configuration ##
########################



######################################
## Azure App services Configuration ## 
######################################



##############################
## Azure Container Registry ##
##############################