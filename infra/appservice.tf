resource "azurerm_service_plan" "plan" {
  name                = var.name
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  os_type             = "Linux"
  sku_name            = "B1"
}

resource "azurerm_linux_web_app" "app" {
  name                = var.name
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_service_plan.plan.location
  service_plan_id     = azurerm_service_plan.plan.id

  identity {
    type = "SystemAssigned"
  }

  site_config {
    always_on = true
    application_stack {
      dotnet_version = "8.0"
    }

    app_command_line = "dotnet productApi.dll"
  }

  app_settings = {
    
    "WEBSITES_PORT"                    = "8080"
    "ASPNETCORE_URLS"                  = "http://0.0.0.0:8080"

    "ConnectionStrings__DefaultConnection" = "Server=test;Database=test;"

    //"ConnectionStrings__DefaultConnection" = "@Microsoft.KeyVault(SecretUri=https://${azurerm_key_vault.vault.name}.vault.azure.net/secrets/${azurerm_key_vault_secret.db_conn.name})"
    
    "WEBSITE_RUN_FROM_PACKAGE"         = "1"
    "WEBSITE_STARTUP_STACK_TYPE"       = "DOTNETCORE"

  }
}