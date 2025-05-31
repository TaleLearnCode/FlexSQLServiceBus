# #############################################################################
# Modules
# #############################################################################

locals {
  region_short = module.region.region.region_short
  architects = var.architect_principal_id
}

module "region" {
  source  = ".//modules/REG"
  azure_region = var.location
}