# #############################################################################
# Key Vault
# #############################################################################

variable "kv_subnet_blocks" {
  type        = list(string)
  default     = []
  description = "The address prefixes for the Key Vault subnet. Should be a /28 CIDR block."
}

module "kv" {
  source = ".//modules/KVM"

  environment             = var.environment
  system_name             = local.systemName
  region_short            = local.region_short
  tenant_id               = var.tenant_id
  resource_group_name     = module.resource_group.name
  location                = module.resource_group.location

  vnet_resource_group     = azurerm_virtual_network.vnet.resource_group_name
  vnet_name               = azurerm_virtual_network.vnet.name
  subnet_address_prefixes = var.kv_subnet_blocks
  
  tags                    = local.tags

  architect_principal_ids = [ local.architects ]
}