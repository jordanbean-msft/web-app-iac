terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">=3.38.0"
    }
  }
  # backend "azurerm" {
  #   resource_group_name  = "rg-webAppIac-ussc-terraform"
  #   storage_account_name = "sawebappiactfstate"
  #   container_name       = "tfstate"
  #   key                  = "terraform.tfstate"
  #   #access_key = $env:ARM_ACCESS_KEY
  # }
}

provider "azurerm" {
  features {
  }
  subscription_id = var.subscription_id
}

module "services" {
  source                    = "./modules/services"
  resource_group_name       = var.resource_group_name
  app                       = var.app
  region                    = var.region
  environment               = var.environment
  location                  = var.location
  sql_username_secret_value = var.sql_username_secret_value
  sql_password_secret_value = var.sql_password_secret_value
}

module "app" {
  source = "./modules/app"
  depends_on = [
    module.services,
    module.data
  ]
  resource_group_name               = var.resource_group_name
  location                          = var.location
  app                               = var.app
  region                            = var.region
  environment                       = var.environment
  log_analytics_workspace_name      = module.services.log_analytics_workspace_name
  application_insights_name         = module.services.application_insights_name
  key_vault_name                    = module.services.key_vault_name
  user_assigned_identity_name       = module.services.user_assigned_identity_name
  sql_connection_string_secret_name = module.data.sql_connection_string_secret_name
  app_service_plan_sku              = var.app_service_plan_sku
}

module "data" {
  source = "./modules/data"
  depends_on = [
    module.services
  ]
  resource_group_name          = var.resource_group_name
  location                     = var.location
  app                          = var.app
  region                       = var.region
  environment                  = var.environment
  log_analytics_workspace_name = module.services.log_analytics_workspace_name
  application_insights_name    = module.services.application_insights_name
  key_vault_name               = module.services.key_vault_name
  user_assigned_identity_name  = module.services.user_assigned_identity_name
  sql_username_secret_name     = module.services.sql_username_secret_name
  sql_password_secret_name     = module.services.sql_password_secret_name
}
