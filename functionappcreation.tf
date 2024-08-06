# Azure Provider Configuration
provider "azurerm" {
  features {}
 
  subscription_id = "954c1a96-f49a-4cee-8cba-b72a71502f76"
}
 
# Create an App Service Plan
resource "azurerm_app_service_plan" "plan" {
  name                   = "azureFunctionAppServicePlan"
  location               = "East US"
  resource_group_name    = "AZ-TF-PROJECT"
  kind                   = "FunctionApp"
 
  sku {
    tier = "Standard"
    size = "S1"
  }
}
 
# Create Function App
resource "azurerm_function_app" "app" {
  name                   = "ankitfunction"
  location               = "East US"
  resource_group_name    = "AZ-TF-PROJECT"
  app_service_plan_id     = azurerm_app_service_plan.plan.id
  storage_account_name    = azurerm_storage_account.sa.name
  storage_account_access_key = azurerm_storage_account.sa.primary_access_key
}
 
# Create Storage account for Function App
resource "azurerm_storage_account" "sa" {
  name                   = "eswarstorage"
  resource_group_name    = "AZ-TF-PROJECT"
  location               = "East US"
  account_tier           = "Standard"
  account_replication_type = "LRS"
}
 
# Output
output "app_service_name" {
  description = "The name of the app service"
  value       = azurerm_function_app.app.name
}
 
output "app_service_default_site_hostname" {
  description = "The default hostname of the app service"
  value       = azurerm_function_app.app.default_hostname
}