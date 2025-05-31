variable "environment" {
  type        = string
  description = "The environment for which resources are being provisioned."
}

variable "system_component_name" {
  type        = string
  description = "System component name used in naming conventions."
}

variable "region_short" {
  type        = string
  description = "Short name of the region used in naming conventions."
}

variable "resource_group_name" {
  type        = string
  description = "The name of the resource group where the App Configuration store will be created."
}

variable "location" {
  type        = string
  description = "Azure region for deployment."
}

variable "app_configuration_soft_delete_retention_days" {
  type        = number
  default     = 7
  description = "Retention period for soft deleted configuration items."
}

variable "app_configuration_purge_protection_enabled" {
  type        = bool
  default     = true
  description = "Whether purge protection is enabled."
}

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

variable "tags" {
  type        = map(string)
  description = "A map of tags to assign to the Resource Group."
}

variable "vnet_resource_group" {
  description = "Resource group for the virtual network"
  type        = string
}

variable "vnet_name" {
  description = "Name of the virtual network"
  type        = string
}

variable "subnet_address_prefixes" {
  description = "Address prefixes for the subnet"
  type        = list(string)
}