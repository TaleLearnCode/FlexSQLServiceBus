variable "environment" {
  type        = string
  description = "The environment for which resources are being provisioned."
}

# -----------------------------------------------------------------------------
# Storage Account Variables
# -----------------------------------------------------------------------------

variable "storage_account_name" {
  description = "The name of the storage account. Must be globally unique and in lowercase."
  type        = string
}

variable "resource_group_name" {
  description = "The name of the resource group in which the storage account will be created."
  type        = string
}

variable "location" {
  description = "The location/region in which to create the storage account."
  type        = string
}

variable "account_tier" {
  description = "The performance tier of the storage account (Standard or Premium)."
  type        = string
  default     = "Standard"
}

variable "account_replication_type" {
  description = "The replication type for the storage account (e.g., LRS, GRS)."
  type        = string
  default     = "LRS"
}

variable "tags" {
  description = "Tags applied to all resources created within this module."
  type        = map(string)
  default     = {}
}

# ------------------------------------------------------------------------------
# Subnet Variables
# ------------------------------------------------------------------------------

variable "is_function_app" {
  description = "Indicates whether the storage subnet is being created for a Function App."
  type        = bool
  default     = false
}

variable "system_name" {
  description = "The system acronym used to uniquely identify the resources. This value will be used to construct names for the subnet and related resources."
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

variable "subnet_address_prefixes" {
  description = "The list of CIDR address prefixes to be used for the subnet."
  type        = list(string)
}

variable "service_endpoints" {
  description = "A list of service endpoints to enable on the subnet."
  type        = list(string)
  default = [
    "Microsoft.AzureCosmosDB",
    "Microsoft.KeyVault",
    "Microsoft.EventHub",
    "Microsoft.ServiceBus",
    "Microsoft.Storage",
    "Microsoft.ContainerRegistry",
    "Microsoft.Sql"
  ]
}

# -----------------------------------------------------------------------------
# Tables and Blob Containers
# -----------------------------------------------------------------------------

variable "tables" {
  description = "List of storage table names to create. Provide an empty list if no tables are required."
  type        = list(string)
  default     = []
}

variable "blob_containers" {
  description = "List of blob container names to create. Provide an empty list if no containers are required."
  type        = list(string)
  default     = []
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