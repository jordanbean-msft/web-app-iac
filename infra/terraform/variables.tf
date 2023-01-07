variable "resource_group_name" {}
variable "location" {}
variable "subscription_id" {}
variable "app" {}
variable "region" {}
variable "environment" {}
variable "sql_username_secret_value" {
  sensitive = true
}
variable "sql_password_secret_value" {
  sensitive = true
}
variable "app_service_plan_sku" {}
