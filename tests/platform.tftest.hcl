mock_provider "azurerm" {}
mock_provider "random" {}
run "secure_defaults" {
  command = plan
  assert {
    condition     = azurerm_storage_account.data.min_tls_version == "TLS1_2"
    error_message = "Storage must require TLS 1.2."
  }
  assert {
    condition     = azurerm_storage_account.data.allow_nested_items_to_be_public == false
    error_message = "Public blob ACLs must be disabled."
  }
  assert {
    condition     = azurerm_linux_function_app.ingest.https_only == true
    error_message = "Function app must require HTTPS."
  }
  assert {
    condition     = azurerm_service_plan.functions.sku_name == "Y1"
    error_message = "Use the demonstration consumption plan."
  }
}
run "invalid_prefix" {
  command = plan
  variables {
    prefix = "INVALID-NAME"
  }
  expect_failures = [var.prefix]
}
