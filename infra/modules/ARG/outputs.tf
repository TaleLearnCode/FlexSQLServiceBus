output "id" {
  description = "The ID of the created Resource Group."
  value       = azurerm_resource_group.rg.id
}

output "name" {
  description = "The name of the created Resource Group."
  value       = azurerm_resource_group.rg.name
}

output "location" {
  description = "The location of the created Resource Group."
  value       = azurerm_resource_group.rg.location
}

output "developer_role_assignment_ids" {
  description = "The IDs of the developer role assignments."
  value       = module.developer_role_assignment.role_assignment_ids
}

output "architect_role_assignment_contributor_ids" {
  description = "The IDs of the architect role assignments for Contributor."
  value       = module.architect_role_assignment_contributor.role_assignment_ids
}

output "architect_role_assignment_reader_ids" {
  description = "The IDs of the architect role assignments for Reader."
  value       = module.architect_role_assignment_reader.role_assignment_ids
}