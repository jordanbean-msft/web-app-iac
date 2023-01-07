output "log_analytics_workspace_name" {
  value = azurerm_log_analytics_workspace.log_analytics_workspace.name
}
output "application_insights_name" {
  value = azurerm_application_insights.application_insights.name
}
output "key_vault_name" {
  value = azurerm_key_vault.key_vault.name
}
output "user_assigned_identity_name" {
  value = azurerm_user_assigned_identity.user_assigned_identity.name
}
output "sql_username_secret_name" {
  value = azurerm_key_vault_secret.sql_username_secret.name
}
output "sql_password_secret_name" {
  value = azurerm_key_vault_secret.sql_password_secret.name
}
