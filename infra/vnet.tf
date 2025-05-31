# #############################################################################
# vnet.tf
# Azure Virtual Network Configuration
# #############################################################################
# This file contains the configuration for the Azure Virtual Network (VNet) resource.
# It defines the VNet with a specific address space and associates it with a resource group.
# #############################################################################

variable "vnet_address_space" {
	type        = list(string)
	description = "Address space for the virtual network."
}

resource "azurerm_virtual_network" "vnet" {
	name                = "vnet-${local.systemComponentName}-${var.environment}-${local.region_short}"
	address_space       = var.vnet_address_space
	location            = var.location
	resource_group_name = module.resource_group.name

	tags = local.tags
}