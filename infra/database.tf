resource "random_password" "sql_password" {
  length  = 16
  special = false
}

resource "azurerm_mssql_server" "server" {
  name                         = var.name
  resource_group_name          = azurerm_resource_group.rg.name
  location                     = var.location2
  version                      = "12.0"
  administrator_login          = "sqladminuser"
  administrator_login_password = "1234-youS"
}

resource "azurerm_mssql_database" "db" {
  name      = var.name
  server_id = azurerm_mssql_server.server.id
  sku_name  = "S0"
}

resource "azurerm_mssql_firewall_rule" "allow_azure" {
  name             = "AllowAzureServices"
  server_id        = azurerm_mssql_server.server.id
  start_ip_address = "0.0.0.0"
  end_ip_address   = "0.0.0.0"
}

resource "azurerm_mssql_firewall_rule" "allow_my_ip" {
  name             = "AllowMyIP"
  server_id        = azurerm_mssql_server.server.id
  start_ip_address = "156.214.16.33"
  end_ip_address   = "156.214.16.33"
}

locals {
  connection_string = "Server=tcp:${azurerm_mssql_server.server.fully_qualified_domain_name},1433;Initial Catalog=${azurerm_mssql_database.db.name};User ID=${azurerm_mssql_server.server.administrator_login};Password=${azurerm_mssql_server.server.administrator_login_password};Encrypt=True;TrustServerCertificate=False;Connection Timeout=30;"
}