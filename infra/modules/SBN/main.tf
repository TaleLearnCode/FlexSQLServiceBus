resource "azurerm_servicebus_namespace" "this" {
  name                         = "sbns-${var.system_component_name}-${var.environment}-${var.region_short}"
  resource_group_name          = var.resource_group_name
  location                     = var.location
  sku                          = var.sku
	local_auth_enabled           = var.local_auth_enabled
	minimum_tls_version          = 1.2
	identity {
		type = "SystemAssigned"
	}
  tags = var.tags
}

# -----------------------------------------------------------------------------
# Role Assignments for Service Bus Namespace
# -----------------------------------------------------------------------------

module "developer_role_assignment" {
  source              = "../CRA"

  environment         = var.environment
  allowed_environments = ["sit", "dev"]  # Developers get "Reader" in SIT & DEV
  principal_ids       = var.developer_principal_ids
  role_definition_name = "Reader"
  scope               = azurerm_servicebus_namespace.this.id
}

module "architect_role_assignment_owner" {
  source              = "../CRA"

  environment         = var.environment
  allowed_environments = ["sit", "dev", "dev", "qa", "e2e"]  # Architects get "App Configuration Data Owner" in SIT, DEV, QA, and E2E
  principal_ids       = var.architect_principal_ids
  role_definition_name = "Reader"
  scope               = azurerm_servicebus_namespace.this.id
}