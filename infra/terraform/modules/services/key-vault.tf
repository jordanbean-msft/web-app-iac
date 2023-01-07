resource "azurerm_key_vault" "key_vault" {
  name                = local.key_vault_name
  location            = var.location
  resource_group_name = var.resource_group_name
  tenant_id           = data.azurerm_client_config.current.tenant_id
  sku_name            = "standard"
}

resource "azurerm_key_vault_access_policy" "admin_access_policy" {
  key_vault_id       = azurerm_key_vault.key_vault.id
  tenant_id          = data.azurerm_client_config.current.tenant_id
  object_id          = data.azurerm_client_config.current.object_id
  secret_permissions = ["Get", "List", "Set", "Delete", "Purge", "Recover", "Restore", "Backup"]
}

resource "azurerm_key_vault_access_policy" "user_assigned_managed_identity_access_policy" {
  key_vault_id       = azurerm_key_vault.key_vault.id
  tenant_id          = data.azurerm_client_config.current.tenant_id
  object_id          = azurerm_user_assigned_identity.user_assigned_identity.principal_id
  secret_permissions = ["Get", "List"]
}

resource "azurerm_key_vault_secret" "sql_username_secret" {
  name         = local.sql_username_secret_name
  value        = var.sql_username_secret_value
  key_vault_id = azurerm_key_vault.key_vault.id
}

resource "azurerm_key_vault_secret" "sql_password_secret" {
  name         = local.sql_password_secret_name
  value        = var.sql_password_secret_value
  key_vault_id = azurerm_key_vault.key_vault.id
}
