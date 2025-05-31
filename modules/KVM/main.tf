# KVM - Key Vault Management Module

# -----------------------------------------------------------------------------
# Key Vault
# -----------------------------------------------------------------------------

resource "azurerm_key_vault" "kv" {
  name                          = lower("kv-${var.system_name}-${var.environment}-${var.region_short}")
  location                      = var.location
  resource_group_name           = var.resource_group_name
  tenant_id                     = var.tenant_id
  soft_delete_retention_days    = 7
  purge_protection_enabled      = true
  sku_name                      = "standard"
  enable_rbac_authorization     = true
  public_network_access_enabled = true
  tags                          = var.tags
}

# -----------------------------------------------------------------------------
# Private Endpoint for Key Vault
# ------------------------------------------------------------------------------

resource "azurerm_subnet" "kv" {
  name = "${var.system_name}-KeyVault"
  resource_group_name  = var.vnet_resource_group
  virtual_network_name = var.vnet_name
  address_prefixes     = var.subnet_address_prefixes
}

#data "azurerm_private_dns_zone" "vault" {
#  name                = "privatelink.vaultcore.azure.net"
#  resource_group_name = var.infra_resource_group_name
#}
#
#resource "azurerm_private_endpoint" "kv" {
#  name                = lower("pep-${var.system_name}-${var.environment}-${var.region_short}")
#  location            = var.location
#  resource_group_name = var.resource_group_name
#  subnet_id           = azurerm_subnet.kv.id
#  
#  #ip_configuration {
#  #  name               = "default"
#  #  private_ip_address = var.private_link_static_ip
#  #}
#
#  private_dns_zone_group {
#    name                 = data.azurerm_private_dns_zone.vault.name
#    private_dns_zone_ids = [data.azurerm_private_dns_zone.vault.id]
#  }
#
#  private_service_connection {
#    is_manual_connection           = false
#    name                           = "KeyVaultConnection"
#    private_connection_resource_id = azurerm_key_vault.kv.id
#    subresource_names              = ["vault"]
#  }
#
#  depends_on = [
#    azurerm_key_vault.kv
#  ]
#}
#
##resource "azurerm_network_interface" "kv" {
##  name                = lower("nic-${var.system_name}-${var.environment}-${var.region_short}")
##  location            = var.location
##  resource_group_name = var.resource_group_name
##
##  ip_configuration {
##    name                          = azurerm_key_vault.kv.name
##    subnet_id                     = azurerm_subnet.kv.id
##    private_ip_address_allocation = "Static"
##    primary                       = true
##    private_ip_address            = var.private_link_static_ip
##  }
##}
#
#resource "azurerm_private_dns_a_record" "kv" {
#  name                = azurerm_key_vault.kv.name
#  records             = [ var.private_link_static_ip]
#  resource_group_name = var.infra_resource_group_name
#  ttl                 = 10
#  zone_name           = data.azurerm_private_dns_zone.vault.name
#  tags                = var.tags
#  depends_on = [
#    data.azurerm_private_dns_zone.vault
#  ]
#}

# -----------------------------------------------------------------------------
# Role Assignments
# ------------------------------------------------------------------------------

module "developer_role_assignment" {
  source              = "../CRA"

  environment          = var.environment
  allowed_environments = ["sit", "dev"]
  principal_ids        = var.developer_principal_ids
  role_definition_name = "Key Vault Secrets User"
  scope                = azurerm_key_vault.kv.id
}

module "architect_key_vault_administrator_role_assignment" {
  source              = "../CRA"

  environment         = var.environment
  allowed_environments = ["sit", "dev", "qa"] 
  principal_ids       = var.architect_principal_ids
  role_definition_name = "Key Vault Administrator"
  scope               = azurerm_key_vault.kv.id
}

module "architect_key_vault_secrets_user_role_assignment" {
  source              = "../CRA"

  environment         = var.environment
  allowed_environments = ["qa", "e2e"] 
  principal_ids       = var.architect_principal_ids
  role_definition_name = "Key Vault Secrets User"
  scope               = azurerm_key_vault.kv.id
}