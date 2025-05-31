# CRA - Conditional Role Assignment Module

locals {
  create_assignment = contains(var.allowed_environments, var.environment)
  principal_map     = local.create_assignment ? { for idx, pid in var.principal_ids : idx => pid } : {}
}

resource "azurerm_role_assignment" "role_assignment" {
  for_each             = local.principal_map
  principal_id         = each.value
  role_definition_name = var.role_definition_name
  scope                = var.scope
}
