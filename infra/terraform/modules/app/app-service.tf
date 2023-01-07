resource "azurerm_linux_web_app" "webApp" {
  name                = local.app_service_name
  resource_group_name = var.resource_group_name
  location            = var.location
  service_plan_id     = azurerm_service_plan.app_service_plan.id
  site_config {
    application_stack {
      dotnet_version = "7.0"
    }
  }
  app_settings = {
    "APPINSIGHTS_INSTRUMENTATIONKEY"             = data.azurerm_application_insights.application_insights.instrumentation_key
    "APPLICATIONINSIGHTS_CONNECTION_STRING"      = data.azurerm_application_insights.application_insights.connection_string
    "ApplicationInsightsAgent_EXTENSION_VERSION" = "~3"
    "XDT_MicrosoftApplicationInsights_Mode"      = "Recommended"
    "WEBSITE_RUN_FROM_PACKAGE"                   = "1"
  }
  connection_string {
    name  = "MyDbConnection"
    type  = "SQLAzure"
    value = "@Microsoft.KeyVault(VaultName=${var.key_vault_name};SecretName=${var.sql_connection_string_secret_name})"
  }
  key_vault_reference_identity_id = data.azurerm_user_assigned_identity.user_assigned_identity.id
  identity {
    type         = "UserAssigned"
    identity_ids = [data.azurerm_user_assigned_identity.user_assigned_identity.id]
  }
}

resource "azurerm_monitor_diagnostic_setting" "web_app_diagnostic_settings" {
  name                       = "logging"
  target_resource_id         = azurerm_linux_web_app.webApp.id
  log_analytics_workspace_id = data.azurerm_log_analytics_workspace.log_analytics_workspace.id
  log {
    category = "AppServiceHTTPLogs"
    enabled  = true
  }
  log {
    category = "AppServiceConsoleLogs"
    enabled  = true
  }
  log {
    category = "AppServiceAppLogs"
    enabled  = true
  }
  log {
    category = "AppServiceAuditLogs"
    enabled  = true
  }
  log {
    category = "AppServiceIPSecAuditLogs"
    enabled  = true
  }
  log {
    category = "AppServicePlatformLogs"
    enabled  = true
  }
  metric {
    category = "AllMetrics"
    enabled  = true
  }
}
