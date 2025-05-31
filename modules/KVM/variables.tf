variable "environment" {
  type        = string
  description = "The environment for which resources are being provisioned."
}

variable "system_name" {
  type        = string
  description = "System name used in naming conventions."
}

variable "region_short" {
  type        = string
  description = "Short name of the region used in naming conventions."
}

variable "tenant_id" {
  type        = string
  description = "Azure Tenant ID."
}

variable "resource_group_name" {
  type        = string
  description = "The name of the resource group where the Key Vault will be created."
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

variable "vnet_resource_group" {
  description = "The resource group containing the existing Virtual Network where the subnet will be created."
  type        = string
}

variable "vnet_name" {
  description = "The name of the existing Virtual Network where the subnet will be created."
  type        = string
}

#variable "vnet_id" {
#  description = "The ID of the existing Virtual Network."
#  type        = string
#  default     = null
#}

variable "subnet_address_prefixes" {
  description = "The list of CIDR address prefixes to be used for the subnet. Should be a /28 or larger."
  type        = list(string)
}

#variable "private_link_static_ip" {
#  description = "Static IP address for the private endpoint if required. Must be within the subnet's address range."
#  type        = string
#  default     = null
#}

#variable "infra_resource_group_name" {
#  description = "The name of the infrastructure resource group."
#  type        = string
#}