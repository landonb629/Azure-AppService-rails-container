######################################
## Azure App services Configuration ## 
######################################
resource "azurerm_service_plan" "serviceplan" {
  name = "${var.deployment_name}-ASP"
  resource_group_name = var.resource_group_name
  location = var.location
  os_type = "Linux"
  sku_name = "S1"
}

resource "azurerm_linux_web_app" "webapp" {
  name = "${var.deployment_name}-linuxwebapp"
  resource_group_name = var.resource_group_name
  location = var.location
  service_plan_id = azurerm_service_plan.serviceplan.id
  virtual_network_subnet_id = data.azurerm_subnet.app_subnet.id
  
  identity {
    type = "SystemAssigned"
  }

  site_config {
    always_on = true 
    ftps_state = "Disabled"
    vnet_route_all_enabled = true 
    default_documents = []

    application_stack { 
    docker_image = var.docker_image
    docker_image_tag = var.docker_image_tag
  }
  }

  logs {
    application_logs { 
      file_system_level = "Information"
    }
  }
}

resource "azurerm_role_assignment" "pull" {
  principal_id = azurerm_linux_web_app.webapp.identity[0].principal_id
  role_definition_name = "AcrPull"
  scope = data.azurerm_container_registry.registry.id
  skip_service_principal_aad_check = true
}


##################
## data sources ##
##################

data "azurerm_subnet" "app_subnet" {
  subnet_name = "app"
  resource_group_name = var.resource_group_name
}

data "azurerm_container_registry" "registry" {
  name = "${var.deployment_name}"
  resource_group_name = var.resource_group_name
}