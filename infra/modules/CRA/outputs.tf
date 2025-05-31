output "role_assignment_ids" {
  description = "The IDs of the created role assignments."
  value       = azurerm_role_assignment.role_assignment[*]
}