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

variable "sku" {
	type        = string
	description = "The SKU for the Service Bus Namespace."
	default     = "Standard"	
}

variable "local_auth_enabled" {
	type        = bool
	description = "Enable local authentication for the Service Bus Namespace."
	default     = false
}