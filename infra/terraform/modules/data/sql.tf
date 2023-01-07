resource "azurerm_mssql_server" "sqlServer" {
  name                         = local.sql_server_name
  resource_group_name          = var.resource_group_name
  location                     = var.location
  version                      = "12.0"
  administrator_login          = data.azurerm_key_vault_secret.sql_username_secret.value
  administrator_login_password = data.azurerm_key_vault_secret.sql_password_secret.value
  minimum_tls_version          = "1.2"
}

resource "azurerm_mssql_database" "db" {
  name         = local.sql_db_name
  server_id    = azurerm_mssql_server.sqlServer.id
  collation    = "SQL_Latin1_General_CP1_CI_AS"
  license_type = "LicenseIncluded"
  sku_name     = "Basic"
}

resource "azurerm_monitor_diagnostic_setting" "db_diagnostic_settings" {
  name                       = "logging"
  target_resource_id         = azurerm_mssql_database.db.id
  log_analytics_workspace_id = data.azurerm_log_analytics_workspace.log_analytics_workspace.id
  log {
    category = "SQLInsights"
    enabled  = true
  }
  log {
    category = "QueryStoreRuntimeStatistics"
    enabled  = true
  }
  log {
    category = "QueryStoreWaitStatistics"
    enabled  = true
  }
  log {
    category = "Errors"
    enabled  = true
  }
}

resource "azurerm_key_vault_secret" "sql_connection_string_secret" {
  name         = local.sql_connection_string_secret_name
  value        = "Server=tcp:${azurerm_mssql_server.sqlServer.fully_qualified_domain_name},1433;Database=${azurerm_mssql_database.db.name};User ID=${data.azurerm_key_vault_secret.sql_username_secret.value};Password=${data.azurerm_key_vault_secret.sql_password_secret.value};Trusted_Connection=False;Encrypt=True;"
  key_vault_id = data.azurerm_key_vault.key_vault.id
}
