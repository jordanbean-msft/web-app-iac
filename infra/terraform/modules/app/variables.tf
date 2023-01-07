variable "resource_group_name" {}
variable "location" {}
variable "app" {}
variable "region" {}
variable "environment" {}
variable "log_analytics_workspace_name" {}
variable "application_insights_name" {}
variable "key_vault_name" {}
variable "user_assigned_identity_name" {}
variable "sql_connection_string_secret_name" {
}
variable "app_service_plan_sku" {}

locals {
  app_service_plan_name = "asp-${var.app}-${var.region}-${var.environment}"
  app_service_name      = "wa-${var.app}-${var.region}-${var.environment}"
}
