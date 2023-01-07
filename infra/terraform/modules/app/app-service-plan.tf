resource "azurerm_service_plan" "app_service_plan" {
  name                = local.app_service_plan_name
  resource_group_name = var.resource_group_name
  location            = var.location
  os_type             = "Linux"
  sku_name            = "S1"
}
