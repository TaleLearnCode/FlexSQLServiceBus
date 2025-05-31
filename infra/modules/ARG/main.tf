resource "azurerm_resource_group" "rg" {
  name     = lower("rg-${var.system_component_name}-${var.environment}-${var.region_short}")
  location = var.location
  tags     = var.tags
}

module "developer_role_assignment" {
  source              = "../CRA"

  environment         = var.environment
  allowed_environments = ["sit", "dev"] 
  principal_ids       = var.developer_principal_ids
  role_definition_name = "Reader"
  scope               = azurerm_resource_group.rg.id
}

module "architect_role_assignment_contributor" {
  source              = "../CRA"

  environment         = var.environment
  allowed_environments = ["sit", "dev", "qa"]
  principal_ids       = var.architect_principal_ids
  role_definition_name = "Contributor"
  scope               = azurerm_resource_group.rg.id
}

module "architect_role_assignment_reader" {
  source              = "../CRA"

  environment         = var.environment
  allowed_environments = ["e2e", "prd"]
  principal_ids       = var.architect_principal_ids
  role_definition_name = "Reader"
  scope               = azurerm_resource_group.rg.id
}

