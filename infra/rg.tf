# #############################################################################
# Resouce Group
# #############################################################################

module "resource_group" {
  source = ".//modules/ARG"

  environment           = var.environment
  system_component_name = local.systemComponentName
  region_short          = local.region_short
  location              = var.location

  architect_principal_ids = [local.architects]

  tags = local.tags
}