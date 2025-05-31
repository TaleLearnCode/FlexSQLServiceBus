######################################################################
# Outputs
######################################################################

output "subnet" {
  description = "The subnet object representing the created subnet."
  value       = azurerm_subnet.subnet
}

output "storage_account" {
  description = "The created Azure Storage Account."
  value       = azurerm_storage_account.this
}

output "storage_tables" {
  description = "The storage tables created (if any)."
  value       = azurerm_storage_table.tables
}

output "storage_containers" {
  description = "The storage blob containers created (if any)."
  value       = azurerm_storage_container.containers
}

output "private_endpoints" {
  description = "The private endpoints created for VNet integration (if any)."
  value       = azurerm_private_endpoint.storage
}

output "private_dns_zones" {
  description = "The private DNS zones created for storage services (if any)."
  value       = azurerm_private_dns_zone.storage
}

output "private_dns_a_records" {
  description = "The private DNS A records created in DNS zones (if any)."
  value       = azurerm_private_dns_a_record.storage
}

output "private_dns_zone_vnet_links" {
  description = "The virtual network links between the VNet and the private DNS zones (if any)."
  value       = azurerm_private_dns_zone_virtual_network_link.storage
}