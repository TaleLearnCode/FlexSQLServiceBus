# #############################################################################
# Outputs
# #############################################################################

output "function_app" {
	value = azurerm_function_app_flex_consumption.this
}

output "key_vault_secrets_user_role_id" {
  description = "The ID of the Key Vault Secrets User role assignment."
  value       = var.assign_key_vault_secrets_user ? azurerm_role_assignment.key_vault_secrets_user[0].id : null
}

output "app_config_owner_role_id" {
  description = "The ID of the App Configuration Data Owner role assignment."
  value       = var.assign_app_config_data_owner ? azurerm_role_assignment.app_config_owner[0].id : null
}

output "app_config_reader_role_id" {
  description = "The ID of the App Configuration Data Reader role assignment."
  value       = var.assign_app_config_data_reader ? azurerm_role_assignment.app_config_reader[0].id : null
}