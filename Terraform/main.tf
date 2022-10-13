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
resource "azurerm_virtual_network" "vnet" {
  name = "${var.deployment_name}"
  resource_group_name = azurerm_resource_group.rg.name
  location = var.location
  address_space = ["10.100.0.0/16"]  
}

resource "azurerm_subnet" "app-subnet" {
  name = "${var.deployment_name}-app"
  address_prefixes = ["10.100.1.0/24"]
  virtual_network_name = azurerm_virtual_network.vnet.name
  resource_group_name = azurerm_resource_group.rg.name

  delegation {
    name = "appservice-delegation"

    service_delegation {
      name = "Microsoft.Web/serverFarms"
      actions = ["Microsoft.Network/virtualNetworks/subnets/action"]
    }
  }
}

resource "azurerm_subnet" "db-subnet" {
  name = "${var.deployment_name}-app"
  address_prefixes = ["10.100.100.0/24"]
  virtual_network_name = azurerm_virtual_network.vnet.name
  resource_group_name = azurerm_resource_group.rg.name

  delegation {
    name = "flexible-server-delegation"

    service_delegation { 
      name = "Microsoft.DBforPostgreSQL/flexibleServers"
      actions = ["Microsoft.Network/virtualNetworks/subnets/join/action"]
    }
  }
}

resource "azurerm_private_dns_zone" "dnszone" {
  name = "railsdb.postgres.database.azure.com"
  resource_group_name = azurerm_resource_group.rg.name
}

resource "azurerm_private_dns_zone_virtual_network_link" "dnslink" {
  name = "${var.deployment_name}-dnslink"
  private_dns_zone_name = azurerm_private_dns_zone.dnszone.name
  virtual_network_id = azurerm_virtual_network.vnet.id
  resource_group_name = azurerm_resource_group.rg.name
  depends_on = [
    azurerm_private_dns_zone.dnszone
  ]
}

##################################
## Azure Database Configuration ##
##################################
resource "azurerm_postgresql_flexible_server" "db" { 
  name = "${var.deployment_name}-database"
  resource_group_name = azurerm_resource_group.rg.name
  location = var.location
  version = var.pg_version
  delegated_subnet_id = azurerm_subnet.db-subnet.id
  administrator_login = "${var.database_username}"
  administrator_password = "${var.database_password}"
  zone = "1"
  private_dns_zone_id = azurerm_private_dns_zone.dnszone.id
  sku_name = "B_Standard_B1ms"
  storage_mb = 65536
  depends_on = [
    azurerm_private_dns_zone_virtual_network_link.dnslink
  ]
}


######################################
## Azure App services Configuration ## 
######################################
resource "azurerm_service_plan" "serviceplan" {
  name = "${var.deployment_name}-ASP"
  resource_group_name = azurerm_resource_group.rg.name
  location = var.location
  os_type = "Linux"
  sku_name = "S1"
}

resource "azurerm_linux_web_app" "webapp" {
  name = "${var.deployment_name}-linuxwebapp"
  resource_group_name = azurerm_resource_group.rg.name
  location = var.location
  service_plan_id = azurerm_service_plan.serviceplan.id
  virtual_network_subnet_id = azurerm_subnet.app-subnet.id
  
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
  depends_on = [
    azurerm_container_registry.registry
  ]
}

resource "azurerm_role_assignment" "pull" {
  principal_id = azurerm_linux_web_app.webapp.identity[0].principal_id
  role_definition_name = "AcrPull"
  scope = azurerm_container_registry.registry.id
  skip_service_principal_aad_check = true
}


##############################
## Azure Container Registry ##
##############################
resource "azurerm_container_registry" "registry" {
  name = "${var.deployment_name}"
  resource_group_name = azurerm_resource_group.rg.name
  location = var.location
  sku = "Basic"
  admin_enabled = true
}