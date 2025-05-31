######################################################################
# Azure Flex Consumption Function App Module (FLX)
#
# This module deploys a Linux-based Azure Flex Consumption Function App
# using the .NET Isolated runtime. The module provisions and configures
# the following key resources:
#
#   • Retrieves regional information via an external Azure Region module.
#   • Leverages the Azure Storage Account module to create a storage account
#     for storing deployment packages and providing storage connectivity.
#   • Creates a Service Plan (flex consumption) for hosting the Function App.
#   • Deploys the Azure Flex Consumption Function App with custom runtime
#     settings, maximum instance count, and memory allocation.
#   • Configures Application Insights for telemetry and integrates with
#     Azure App Configuration for dynamic application settings.
#   • Grants the Function App (via its system-assigned identity) the
#     "App Configuration Data Reader" role to securely access App Configuration.
#
# The module accepts a set of inputs covering resource group, location, environment,
# and various configuration parameters (including for networking, service plan, and app settings).
#
# This header serves to document the module's purpose, resources created, and 
# integration with other modules (such as the Azure Region and Storage Account modules).
######################################################################

# -----------------------------------------------------------------------------
# Storage Account
# -----------------------------------------------------------------------------

module "storage_account" {
  source                   = "../STA/"
  
	storage_account_name     = lower("st${var.system_component_name}func${var.environment}${var.region_short}")
  resource_group_name      = var.resource_group_name
  location                 = var.location
  environment              = var.environment
  account_tier             = "Standard"
  account_replication_type = "LRS"
  
  is_function_app          = true

  system_name              = var.system_component_name
	
  vnet_resource_group      = var.vnet_resource_group
  vnet_name                = var.vnet_name
  subnet_address_prefixes  = var.storage_subnet_address_prefixes
	
  blob_containers = ["deploymentpackage"]
	
	tags = var.tags
}

# -----------------------------------------------------------------------------
# App Service Plan
# -----------------------------------------------------------------------------

resource "azurerm_service_plan" "this" {
  name                = "asp-${var.system_component_name}-${var.environment}-${var.region_short}"
  resource_group_name = var.resource_group_name
  location            = var.location
  sku_name            = var.func_service_plan_sku
  os_type             = var.func_os_type
}

# -----------------------------------------------------------------------------
# Virtual Network
# -----------------------------------------------------------------------------

resource "azurerm_subnet" "vnet" {
  name = "${var.system_component_name}-FunctionApp-VirtualNetwork"

  resource_group_name  = var.vnet_resource_group
  virtual_network_name = var.vnet_name
  address_prefixes     = var.function_app_virtual_network_address_prefixes
  delegation {
    name = "FunctionAppDelegation"
    service_delegation {
      name    = "Microsoft.Web/serverFarms"
      actions = ["Microsoft.Network/virtualNetworks/subnets/join/action"]
    }
  }
  lifecycle {
    ignore_changes = [delegation]
  }
}

# -----------------------------------------------------------------------------
# Private Endpoint
# -----------------------------------------------------------------------------

resource "azurerm_subnet" "private_endpoint" {
  name = "${var.system_component_name}-FunctionApp-PrivateEndpoint"

  resource_group_name  = var.vnet_resource_group
  virtual_network_name = var.vnet_name
  address_prefixes     = var.function_app_private_endpoint_address_prefixes
}

#data "azurerm_private_dns_zone" "azure_websites" {
#  name                = "privatelink.azurewebsites.net"
#  resource_group_name = var.infra_resource_group_name
#}
#
#resource "azurerm_network_interface" "function_app" {
#  name                = "nic-${var.system_component_name}-${var.environment}-${var.region_short}"
#  location            = var.location
#  resource_group_name = var.resource_group_name
#
#  ip_configuration {
#    name                          = "default"
#    subnet_id                     = azurerm_subnet.private_endpoint.id
#    private_ip_address_allocation = "Dynamic"
#  }
#}
#
#resource "azurerm_private_endpoint" "function_app" {
#  name                = "pep-${var.system_component_name}-${var.environment}-${var.region_short}"
#  location            = var.location
#  resource_group_name = var.resource_group_name
#  subnet_id           = azurerm_subnet.private_endpoint.id
#  tags                = var.tags
#  private_dns_zone_group {
#    name                 = azurerm_function_app_flex_consumption.this.name
#    private_dns_zone_ids = [data.azurerm_private_dns_zone.azure_websites.id]
#  }
#  private_service_connection {
#    name                           = azurerm_function_app_flex_consumption.this.name
#    is_manual_connection           = false
#    private_connection_resource_id = azurerm_function_app_flex_consumption.this.id
#    subresource_names              = ["sites"]
#  }
#}

# -----------------------------------------------------------------------------
# Function App
# -----------------------------------------------------------------------------

resource "azurerm_function_app_flex_consumption" "this" {
  name                = "func-${var.system_component_name}-${var.environment}-${var.region_short}"
  resource_group_name = var.resource_group_name
  location            = var.location
  service_plan_id     = azurerm_service_plan.this.id

  storage_container_type      = "blobContainer"
  storage_container_endpoint  = "${module.storage_account.storage_account.primary_blob_endpoint}deploymentpackage"
  storage_authentication_type = "StorageAccountConnectionString"
  storage_access_key          = module.storage_account.storage_account.primary_access_key
  runtime_name                = var.runtime_name
  runtime_version             = var.runtime_version
  maximum_instance_count      = var.maximum_instance_count
  instance_memory_in_mb       = var.instance_memory_in_mb

  #virtual_network_subnet_id     = azurerm_subnet.vnet.id
  #public_network_access_enabled = false

  identity {
    type = "SystemAssigned"
  }

	site_config {
		application_insights_connection_string = var.application_insights_connection_string
		application_insights_key               = var.application_insights_key
    cors {
      allowed_origins = ["https://portal.azure.com"]
    }
	}

  app_settings = merge(
    {
      "APPCONFIG_URL" = var.app_configuration_endpoint
    },
    local.dynamic_app_settings
  )

  tags = var.tags

  lifecycle {
    ignore_changes = [ 
      virtual_network_subnet_id
     ]
  }

}

# -----------------------------------------------------------------------------
# Role Assignments
# -----------------------------------------------------------------------------

resource "azurerm_role_assignment" "key_vault_secrets_user" {
  count                = var.assign_key_vault_secrets_user ? 1 : 0
  principal_id         = azurerm_function_app_flex_consumption.this.identity[0].principal_id
  role_definition_name = "Key Vault Secrets User"
  scope               = var.key_vault_id
}

resource "azurerm_role_assignment" "app_config_owner" {
  count                = var.assign_app_config_data_owner ? 1 : 0
  principal_id         = azurerm_function_app_flex_consumption.this.identity[0].principal_id
  role_definition_name = "App Configuration Data Owner"
  scope               = var.app_configuration_id
}

resource "azurerm_role_assignment" "app_config_reader" {
  count                = var.assign_app_config_data_reader ? 1 : 0
  principal_id         = azurerm_function_app_flex_consumption.this.identity[0].principal_id
  role_definition_name = "App Configuration Data Reader"
  scope               = var.app_configuration_id
}

module "developer_role_assignment" {
  source              = "../CRA"

  environment         = var.environment
  allowed_environments = ["dev"] 
  principal_ids       = var.developer_principal_ids
  role_definition_name = "Contributor"
  scope               = azurerm_function_app_flex_consumption.this.id
}


module "architect_role_assignment_contributor" {
  source              = "../CRA"

  environment         = var.environment
  allowed_environments = ["dev"]
  principal_ids       = var.architect_principal_ids
  role_definition_name = "Contributor"
  scope               = azurerm_function_app_flex_consumption.this.id
}
