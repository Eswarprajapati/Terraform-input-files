output "resource_group_name" {
  description = "Demo resource group."
  value       = azurerm_resource_group.data.name
}
output "function_app_name" {
  description = "Function application name; no access keys are output."
  value       = azurerm_linux_function_app.ingest.name
}
output "function_hostname" {
  description = "Function app hostname; the sample route requires a function key."
  value       = azurerm_linux_function_app.ingest.default_hostname
}
