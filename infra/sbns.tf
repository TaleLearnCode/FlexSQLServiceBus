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

module "service_bus_topic" {
  source = ".//modules/SBT"

  environment                        = var.environment
  name                               = "PodsListUpdated"
  namespace_id                       = module.serice_bus.service_bus_namespace.id
  architect_principal_ids            = [local.architects]
}

module "service_bus_subscription" {
  source = ".//modules/SBS"

  environment                        = var.environment
  name                               = "BusinessInspection"
  topic_id                           = module.service_bus_topic.topic.id
  architect_principal_ids            = [local.architects]
}