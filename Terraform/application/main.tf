######################################
## Azure App services Configuration ## 
######################################
resource "azurerm_service_plan" "serviceplan" {
  name = "${var.deployment_name}-ASP"
  resource_group_name = var.deployment_name
  location = var.location
  os_type = "Linux"
  sku_name = "S1"
}

resource "azurerm_linux_web_app" "webapp" {
  name = "${var.deployment_name}-linuxwebapp"
  resource_group_name = var.deployment_name
  location = var.location
  service_plan_id = azurerm_service_plan.serviceplan.id
  virtual_network_subnet_id = data.azurerm_subnet.app_subnet.id

  app_settings = {  
    "DOCKER_REGISTRY_SERVER_PASSWORD" = "NR8hVtF2Yc+dBOTHSFvm1uayNjC5aD8P"
    "DOCKER_REGISTRY_SERVER_URL" = "demorailsazure.azurecr.io"
    "DOCKER_REGISTRY_SERVER_USERNAME" = "demorailsazure"
    "WEBSITES_ENABLE_APP_SERVICE_STORAGE" = "false"

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


##################
## data sources ##
##################

data "azurerm_subnet" "app_subnet" {
  name = "app"
  virtual_network_name = "${var.deployment_name}"
  resource_group_name = var.deployment_name
}

data "azurerm_container_registry" "registry" {
  name = "${var.deployment_name}"
  resource_group_name = var.deployment_name
}