# #############################################################################
# Providers
# #############################################################################

terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>4.0"
    }
    azuread = {
      source  = "hashicorp/azuread"
      version = "~> 3.3.0"
    }
  }
}

provider "azurerm" {
	subscription_id = var.subscription_id
  tenant_id = var.tenant_id
  features {
    key_vault {
      purge_soft_delete_on_destroy    = true
      recover_soft_deleted_key_vaults = true
    }
  }
}

provider "azuread" {
  tenant_id = var.tenant_id
}

data "azurerm_client_config" "current" {}