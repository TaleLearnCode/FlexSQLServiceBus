output "key_vault" {
  description = "The Key Vault resource."
  value       = azurerm_key_vault.kv
}

output "developer_role_assignment_ids" {
  description = "The IDs of the developer role assignments."
  value       = module.developer_role_assignment.role_assignment_ids
}

output "architect_key_vault_secrets_user_role_assignment_ids" {
  description = "The IDs of the architect Key Vault Secrets User role assignments."
  value       = module.architect_key_vault_secrets_user_role_assignment.role_assignment_ids
}

output "architect_key_vault_administrator_role_assignment_ids" {
  description = "The IDs of the architect Key Vault Administrator role assignments."
  value       = module.architect_key_vault_administrator_role_assignment.role_assignment_ids
}