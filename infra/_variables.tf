# #############################################################################
# Project-Level Variables and Locals
# #############################################################################

locals {
	systemName              = "flx"
	componentName           = "sql"
	systemComponentName     = "${local.systemName}${local.componentName}"
}

variable "tenant_id" {
  type        = string
  description = "Identifier of the Azure AD tenant."
} 

variable "subscription_id" {
  type        = string
  description = "Identifier of the Azure subscription."
}

variable "environment" {
  type        = string
  description = "Environment for the resources."
}

variable "location" {
  type        = string
  description = "Location for the resources."
}

variable "architect_principal_id" {
  type        = string
  description = "Azure AD principal ID for the architect."
}