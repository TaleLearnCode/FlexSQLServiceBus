# #############################################################################
# Variables
# #############################################################################

variable "resource_group_name" {
  description = "Name of the Resource Group where to create the Function App resources."
	type        = string
}

variable "location" {
  description = "The Azure Region in which all of the Function App resources will be created."
	type        = string
}

variable "environment" {
	description = "The environment in which all of the Function App resources will be created."
	type        = string
}

variable "system_component_name" {
	description = "The name of the system component."
	type        = string
}

variable "region_short" {
	description = "Short name of the Azure Region for resource naming."
	type        = string
}

variable "vnet_resource_group" {
  description = "The resource group containing the existing Virtual Network where the subnet will be created."
  type        = string
}

variable "vnet_name" {
  description = "The name of the existing Virtual Network where the subnet will be created."
  type        = string
}

variable "storage_subnet_address_prefixes" {
  description = "The list of CIDR address prefixes to be used for the subnet."
  type        = list(string)
}

variable "function_app_virtual_network_address_prefixes" {
	description = "The list of CIDR address prefixes to be used for the Function App virtual network subnet."
	type        = list(string)
}

variable "function_app_private_endpoint_address_prefixes" {
	description = "The list of CIDR address prefixes to be used for the Function App private endpoint subnet."
	type        = list(string)
}

variable "tags" {
  type        = map(string)
  default     = {}
  description = "A map of tags to apply to all resources."
}

variable "func_service_plan_sku" {
	type        = string
	default     = "FC1"
	description = "SKU for the Function App Service Plan."
}

variable "func_os_type" {
	type        = string
	default     = "Linux"
	description = "The OS type for the Function App."
}

variable "runtime_name" {
	type        = string
	default     = "dotnet-isolated"
	description = "The runtime for the Function App."
}

variable "runtime_version" {
	type        = string
	default     = "8.0"
	description = "The runtime version for the Function App."
}

variable "maximum_instance_count" {
	type        = number
	default     = 100
	description = "The maximum instance count for the Function App."
}

variable "instance_memory_in_mb" {
	type        = number
	default     = 2048
	description = "The instance memory for the Function App instances."
}

variable "application_insights_connection_string" {
	type        = string
	default     = null
	description = "The Connection String for linking the Linux Function App to Application Insights."
}

variable "application_insights_key" {
	type 			  = string
	default     = null
	description = "The Instrumentation Key for linking the Linux Function App to Application Insights."
}

variable "app_configuration_endpoint" {
	type 			  = string
	default     = null
	description = "The endpoint for the App Configuration."
}

variable "app_configuration_id" {
	type        = string
	default     = null
	description = "The identifier for the App Configuration."
}

variable "app_configuration_app_settings" {
  description = "Map of app setting names to a configuration object containing the App Configuration key and optional label"
  type = map(object({
    key   = string
    label = optional(string)
  }))
  default = {}  # default as empty; consumer can supply entries as needed.
}

locals {
  dynamic_app_settings = {
    for setting_name, setting_obj in var.app_configuration_app_settings :
    setting_name => "@Microsoft.AppConfiguration(Endpoint=${var.app_configuration_endpoint};Key=${setting_obj.key}${setting_obj.label != null ? ";Label=${setting_obj.label}" : ""})"
  }
}

variable "assign_key_vault_secrets_user" {
  type        = bool
  default     = false
  description = "If true, assigns Key Vault Secrets User role to the Function App."
}

variable "assign_app_config_data_owner" {
  type        = bool
  default     = false
  description = "If true, assigns App Configuration Data Owner role to the Function App."
}

variable "assign_app_config_data_reader" {
  type        = bool
  default     = false
  description = "If true, assigns App Configuration Data Reader role to the Function App."
}

variable "key_vault_id" {
	type        = string
	default     = null
	description = "The identifier for the Key Vault."
}

# -----------------------------------------------------------------------------
# Access Control Variables
# -----------------------------------------------------------------------------

variable "developer_principal_ids" {
  type        = list(string)
  description = "List of principal IDs for developers."
  default     = []
}

variable "architect_principal_ids" {
  type        = list(string)
  description = "List of principal IDs for architects."
  default     = []
}