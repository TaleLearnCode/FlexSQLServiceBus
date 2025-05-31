###############################################################################
# Azure Storage Account Module (STA)
#
# This module provisions an Azure Storage Account along with ancillary
# network resources required for secure connectivity. It performs the
# following tasks:
#
#   1. Creates a dedicated subnet in an existing Virtual Network.
#      - The subnet name is based on the provided system_name and an
#        "is_function_app" flag:
#          - If false: "<system_name>-storageaccount"
#          - If true:  "<system_name>-storageaccount-func"
#      - The subnet is configured with a list of CIDR address prefixes and
#        a set of service endpoints for various Azure services.
#
#   2. Creates an Azure Storage Account with the specified performance tier
#      and replication type.
#
#   3. Optionally creates Storage Tables and Blob Containers if table or
#      container names are provided.
#
#   4. Configures Private Endpoints to enable secure network connectivity.
#      - For each storage service (blob, file, queue, table), a private
#        endpoint is created.
#      - Corresponding Private DNS Zones, DNS A records, and Virtual Network
#        Links are created to facilitate internal name resolution.
#
# Naming Convention:
#   - The Storage Account name must be globally unique and in lowercase.
#   - The subnet name follows the pattern based on "system_name" and the
#     "is_function_app" flag.
#
# Usage:
#   Provide values for your storage account and subnet variables along with
#   networking details. This module is meant to be integrated into a larger
#   Terraform configuration where multiple resource modules coexist.
###############################################################################

######################################################################
# Resources
######################################################################

//
// Get a data source for the virtual network
//
data "azurerm_virtual_network" "vnet" {
  name                = var.vnet_name
  resource_group_name = var.vnet_resource_group
}

//
// Create a subnet for the storage account
//
resource "azurerm_subnet" "subnet" {
  name = var.is_function_app ? "${var.system_name}-FunctionApp-StorageAccount" : "${var.system_name}-StorageAccount"

  resource_group_name  = data.azurerm_virtual_network.vnet.resource_group_name
  virtual_network_name = data.azurerm_virtual_network.vnet.name
  address_prefixes     = var.subnet_address_prefixes

  service_endpoints = var.service_endpoints
}

//
// Create the storage account
//
resource "azurerm_storage_account" "this" {
  name                     = var.storage_account_name
  resource_group_name      = var.resource_group_name
  location                 = var.location
  account_tier             = var.account_tier
  account_replication_type = var.account_replication_type
  tags                     = var.tags
}

//
// Create the storage tables
//
resource "azurerm_storage_table" "tables" {
  for_each             = toset(var.tables)
  name                 = each.value
  storage_account_name = azurerm_storage_account.this.name
}

//
// Create the blob containers
//
resource "azurerm_storage_container" "containers" {
  for_each              = toset(var.blob_containers)
  name                  = each.value
  storage_account_id    = azurerm_storage_account.this.id
  container_access_type = "private"
}

//
// Define local mapping for storage services
//
locals {
  storage_services = {
    blob  = { dns_zone_suffix = "blob.core.windows.net", subresource_name = "blob" }
    file  = { dns_zone_suffix = "file.core.windows.net", subresource_name = "file" }
    queue = { dns_zone_suffix = "queue.core.windows.net", subresource_name = "queue" }
    table = { dns_zone_suffix = "table.core.windows.net", subresource_name = "table" }
  }


  computed_dns_a_records = {
    blob  = cidrhost(var.subnet_address_prefixes[0], 4)
    file  = cidrhost(var.subnet_address_prefixes[0], 5)
    queue = cidrhost(var.subnet_address_prefixes[0], 6)
    table = cidrhost(var.subnet_address_prefixes[0], 7)
  }

}

//
// Create Private Endpoints (if VNet integration is enabled)
//
resource "azurerm_private_endpoint" "storage" {
  for_each = local.storage_services

  name                = "pep-${var.storage_account_name}-${each.key}"
  location            = azurerm_storage_account.this.location
  resource_group_name = var.resource_group_name
  subnet_id           = azurerm_subnet.subnet.id
  tags                = var.tags

  private_service_connection {
    name                           = "${each.key}-private-link"
    is_manual_connection           = false
    private_connection_resource_id = azurerm_storage_account.this.id
    subresource_names              = [each.value.subresource_name]
  }
}

//
// Create Private DNS Zones for each storage service (if VNet integration is enabled)
//
resource "azurerm_private_dns_zone" "storage" {
  for_each            = local.storage_services
  name                = "privatelink-${var.storage_account_name}.${each.value.dns_zone_suffix}"
  resource_group_name = var.resource_group_name
  tags                = var.tags
}

//
// Create DNS A Records in each Private DNS Zone (if VNet integration is enabled)
//
resource "azurerm_private_dns_a_record" "storage" {
  for_each            = local.storage_services
  name                = var.storage_account_name
  zone_name           = azurerm_private_dns_zone.storage[each.key].name
  resource_group_name = var.resource_group_name
  ttl                 = 10
  records             = [local.computed_dns_a_records[each.key]]
  tags                = var.tags
}

//
// Create Virtual Network Links to the Private DNS Zones (if VNet integration is enabled)
//
resource "azurerm_private_dns_zone_virtual_network_link" "storage" {
  for_each              = local.storage_services
  name                  = "${azurerm_private_dns_zone.storage[each.key].name}-link"
  private_dns_zone_name = azurerm_private_dns_zone.storage[each.key].name
  resource_group_name   = var.resource_group_name
  virtual_network_id    = data.azurerm_virtual_network.vnet.id
  tags                  = var.tags
}

# -----------------------------------------------------------------------------
# Role Assignments
# -----------------------------------------------------------------------------

module "developer_contributor_role_assignment" {
  source              = "../CRA"

  environment         = var.environment
  allowed_environments = ["sit", "dev", "dev2"] 
  principal_ids       = var.developer_principal_ids
  role_definition_name = "Storage Table Data Contributor"
  scope               = azurerm_storage_account.this.id
}

module "developer_role_assignment" {
  source              = "../CRA"

  environment         = var.environment
  allowed_environments = ["qa", "e2e"] 
  principal_ids       = var.developer_principal_ids
  role_definition_name = "Storage Table Data Reader"
  scope               = azurerm_storage_account.this.id
}


module "architect_role_assignment_contributor" {
  source              = "../CRA"

  environment         = var.environment
  allowed_environments = ["sit", "dev", "dev2"]
  principal_ids       = var.architect_principal_ids
  role_definition_name = "Storage Table Data Contributor"
  scope               = azurerm_storage_account.this.id
}

module "architect_role_assignment_reader" {
  source              = "../CRA"

  environment         = var.environment
  allowed_environments = ["qa", "e2e"]
  principal_ids       = var.architect_principal_ids
  role_definition_name = "Reader"
  scope               = azurerm_storage_account.this.id
}