output "app_configuration" {
  description = "The App Configuration Store."
  value       = azurerm_app_configuration.appcs
}

output "developer_role_assignment_ids" {
  description = "The IDs of the developer role assignments."
  value       = module.developer_role_assignment.role_assignment_ids
}

output "architect_role_assignment_owner_ids" {
  description = "The IDs of the architect role assignments for App Configuration Data Owner."
  value       = module.architect_role_assignment_owner.role_assignment_ids
}

output "architect_role_assignment_reader_ids" {
  description = "The IDs of the architect role assignments for App Configuration Data Reader."
  value       = module.architect_role_assignment_reader.role_assignment_ids
}