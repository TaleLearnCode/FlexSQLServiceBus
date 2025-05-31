# -----------------------------------------------------------------------------
# App Configuration Service
# -----------------------------------------------------------------------------

resource "azurerm_app_configuration" "appcs" {
  name                       = "appcs-${var.system_component_name}-${var.environment}-${var.region_short}"
  resource_group_name        = var.resource_group_name
  location                   = var.location
  sku                        = "standard"
  local_auth_enabled         = true
  public_network_access      = "Enabled"
  purge_protection_enabled   = var.app_configuration_purge_protection_enabled
  soft_delete_retention_days = var.app_configuration_soft_delete_retention_days
  tags                       = var.tags
}

# -----------------------------------------------------------------------------
# Private Endpoint for App Configuration Service
# -----------------------------------------------------------------------------

resource "azurerm_subnet" "appcs" {
  name = "${var.system_component_name}-AppConfig"
  resource_group_name  = var.vnet_resource_group
  virtual_network_name = var.vnet_name
  address_prefixes     = var.subnet_address_prefixes
}

# -----------------------------------------------------------------------------
# Role Assignments for App Configuration Service
# -----------------------------------------------------------------------------

module "developer_role_assignment" {
  source              = "../CRA"

  environment         = var.environment
  allowed_environments = ["sit", "dev"]  # Developers get "App Configuration Data Reader" in SIT & DEV
  principal_ids       = var.developer_principal_ids
  role_definition_name = "App Configuration Data Reader"
  scope               = azurerm_app_configuration.appcs.id
}

module "architect_role_assignment_owner" {
  source              = "../CRA"

  environment         = var.environment
  allowed_environments = ["sit", "dev"]  # Architects get "App Configuration Data Owner" in SIT & DEV
  principal_ids       = var.architect_principal_ids
  role_definition_name = "App Configuration Data Owner"
  scope               = azurerm_app_configuration.appcs.id
}

module "architect_role_assignment_reader" {
  source = "../CRA"

  environment          = var.environment
  allowed_environments = ["qa", "e2e"]  # Architects get "App Configuration Data Reader" in QA & E2E
  principal_ids        = var.architect_principal_ids
  role_definition_name = "App Configuration Data Reader"
  scope                = azurerm_app_configuration.appcs.id
}