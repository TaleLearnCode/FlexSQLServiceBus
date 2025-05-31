# #############################################################################
# sbns.tf
# Azure Service Bus Namespace
# -----------------------------------------------------------------------------
# This file defines the Azure Service Bus Namespace and its associated role assignments.
# #############################################################################

module "serice_bus" {
  source = ".//modules/SBN"

  environment           = var.environment
  system_component_name = local.systemName
  region_short          = local.region_short
  resource_group_name   = module.resource_group.name
  location              = module.resource_group.location

  architect_principal_ids = [local.architects]

  tags = local.tags
}