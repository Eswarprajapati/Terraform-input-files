locals {
  tags = {
    project     = "data-platform-portfolio"
    environment = var.environment
    managed_by  = "terraform"
  }
}
resource "random_string" "suffix" {
  length  = 6
  upper   = false
  special = false
}
resource "azurerm_resource_group" "data" {
  name     = "${var.prefix}-${var.environment}-rg"
  location = var.location
  tags     = local.tags
}
resource "azurerm_storage_account" "data" {
  name                            = "${var.prefix}${random_string.suffix.result}"
  resource_group_name             = azurerm_resource_group.data.name
  location                        = azurerm_resource_group.data.location
  account_tier                    = "Standard"
  account_replication_type        = "LRS"
  min_tls_version                 = "TLS1_2"
  https_traffic_only_enabled      = true
  allow_nested_items_to_be_public = false
  tags                            = local.tags
  blob_properties {
    versioning_enabled = true
    delete_retention_policy {
      days = 7
    }
  }
}
resource "azurerm_service_plan" "functions" {
  name                = "${var.prefix}-${var.environment}-plan"
  resource_group_name = azurerm_resource_group.data.name
  location            = azurerm_resource_group.data.location
  os_type             = "Linux"
  sku_name            = "Y1"
  tags                = local.tags
}
resource "azurerm_linux_function_app" "ingest" {
  name                       = "${var.prefix}-${var.environment}-${random_string.suffix.result}-func"
  resource_group_name        = azurerm_resource_group.data.name
  location                   = azurerm_resource_group.data.location
  service_plan_id            = azurerm_service_plan.functions.id
  storage_account_name       = azurerm_storage_account.data.name
  storage_account_access_key = azurerm_storage_account.data.primary_access_key
  https_only                 = true
  tags                       = local.tags
  identity {
    type = "SystemAssigned"
  }
  site_config {
    minimum_tls_version = "1.2"
    ftps_state          = "Disabled"
    application_stack {
      python_version = "3.11"
    }
  }
  app_settings = {
    FUNCTIONS_WORKER_RUNTIME       = "python"
    SCM_DO_BUILD_DURING_DEPLOYMENT = "true"
    ENABLE_ORYX_BUILD              = "true"
  }
}
resource "azurerm_role_assignment" "blob_writer" {
  scope                = azurerm_storage_account.data.id
  role_definition_name = "Storage Blob Data Contributor"
  principal_id         = azurerm_linux_function_app.ingest.identity[0].principal_id
}
