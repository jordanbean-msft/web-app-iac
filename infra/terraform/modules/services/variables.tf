variable "resource_group_name" {}
variable "location" {}
variable "app" {}
variable "region" {}
variable "environment" {}
variable "sql_username_secret_value" {
  sensitive = true
}
variable "sql_password_secret_value" {
  sensitive = true
}

locals {
  log_analytics_workspace_name = "la-${var.app}-${var.region}-${var.environment}"
  application_insights_name    = "ai-${var.app}-${var.region}-${var.environment}"
  key_vault_name               = "kv-${var.app}${var.environment}"
  user_assigned_identity_name  = "mi-${var.app}-${var.region}-${var.environment}"
  sql_username_secret_name     = "sqls-${var.app}-${var.region}-${var.environment}-username"
  sql_password_secret_name     = "sqls-${var.app}-${var.region}-${var.environment}-password"
}
