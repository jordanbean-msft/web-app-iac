variable "resource_group_name" {}
variable "location" {}
variable "app" {}
variable "region" {}
variable "environment" {}
variable "log_analytics_workspace_name" {}
variable "application_insights_name" {}
variable "key_vault_name" {}
variable "user_assigned_identity_name" {}
variable "sql_username_secret_name" {
  sensitive = true
}
variable "sql_password_secret_name" {
  sensitive = true
}

locals {
  sql_server_name                   = lower("sql-${var.app}-${var.region}-${var.environment}")
  sql_db_name                       = "db-${var.app}-${var.region}-${var.environment}"
  sql_connection_string_secret_name = "sqlConnectionString"
}
