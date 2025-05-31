# #############################################################################
# appcs.tf
# Azure App Configuration Store
# #############################################################################
# This file contains the configuration for the Azure App Configuration Store.
# It defines the App Configuration Store with soft delete retention and purge protection settings.
# It also includes the configuration for the subnet where the App Configuration Store will be deployed.
# #############################################################################


variable "app_configuration_soft_delete_retention_days" {
  type        = number
  default     = 7
  description = "The number of days to retain soft deleted configuration items. Default is 7."
}

variable "app_configuration_purge_protection_enabled" {
  type        = bool
  default     = true
  description = "Whether purge protection is enabled for the App Configuration Store. Default is false."
}

variable "appcs_subnet_blocks" {
  type        = list(string)
  default     = []
  description = "The address prefixes for the Key Vault subnet. Should be a /28 CIDR block."
}

module "appcs" {
  source = ".//modules/ACS"

  environment           = var.environment
  system_component_name = local.systemName
  region_short          = local.region_short
  resource_group_name   = module.resource_group.name
  location              = module.resource_group.location
  tags                  = local.tags

  app_configuration_soft_delete_retention_days = var.app_configuration_soft_delete_retention_days
  app_configuration_purge_protection_enabled   = var.app_configuration_purge_protection_enabled

  vnet_resource_group     = azurerm_virtual_network.vnet.resource_group_name
  vnet_name               = azurerm_virtual_network.vnet.name
  subnet_address_prefixes = var.appcs_subnet_blocks

  architect_principal_ids = [local.architects]

}