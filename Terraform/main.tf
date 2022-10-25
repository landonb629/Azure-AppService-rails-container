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
  name = "app"
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
  name = "db"
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
/*
##################################
## Azure Database Configuration ##
##################################
resource "azurerm_postgresql_flexible_server" "db" { 
  name = "${var.deployment_name}-server"
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

resource "azurerm_postgresql_flexible_server_database" "rails-db" {
  name = "Azureapp_production"
  server_id = azurerm_postgresql_flexible_server.db.id
  collation = "en_US.utf8"

}
*/
##############################
## azure container instance ## 
##############################

resource "azurerm_container_group" "db" {
  name = "Azureapp_production"
  location = "eastus"
  resource_group_name = azurerm_resource_group.rg.name
  ip_address_type = "Private"
  os_type = "Linux"

  container {
    name = "postgres-instance"
    image = "postgres:latest"
    cpu = "1"
    memory = "1"
    environment_variables = {
      "POSTGRES_DB" = "Azureapp_production",
      "POSTGRES_USER" = "postgres",
      "POSTGRES_PASSWORD" = "DemoPassword123!"
    }

    ports { 
      port = 5432
      protocol = "TCP"
    }
  }
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
