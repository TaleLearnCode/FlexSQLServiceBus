variable "sql_admin_username" {
	type        = string
	description = "The administrator username for the SQL server."
}

variable "sql_admin_password" {
	type        = string
	description = "The administrator password for the SQL server."
}

variable "sql_azuread_admin_username" {
	type        = string
	description = "The Azure AD administrator username for the SQL server."
}

variable "sql_azuread_admin_object_id" {
	type        = string
	description = "The Azure AD administrator object ID for the SQL server."
}

variable "sql_firewall_rules" {
  type = list(object({
    name             = string
    start_ip_address = string
    end_ip_address   = string
  }))
}

resource "azurerm_mssql_server" "flxsql" {
	name                          = "sql-${local.systemComponentName}-${var.environment}-${local.region_short}"
	resource_group_name           = module.resource_group.name
	location                      = module.resource_group.location
	version                       = "12.0"
	administrator_login           = var.sql_admin_username
	administrator_login_password  = var.sql_admin_password
	public_network_access_enabled = true

	azuread_administrator {
		login_username              = var.sql_azuread_admin_username
		object_id                   = var.sql_azuread_admin_object_id
		tenant_id                   = var.tenant_id
		azuread_authentication_only = false
	}

	identity {
		type = "SystemAssigned"
	}

	tags = {
		environment = var.environment
	}
}

resource "azurerm_mssql_firewall_rule" "rules" {
  for_each         = { for rule in var.sql_firewall_rules : rule.name => rule }
  name             = each.value.name
  server_id        = azurerm_mssql_server.flxsql.id
  start_ip_address = each.value.start_ip_address
  end_ip_address   = each.value.end_ip_address
}

resource "azurerm_mssql_database" "flxsql" {
	name                        = "sqldb-${local.systemComponentName}-${var.environment}-${local.region_short}"
	server_id                   = azurerm_mssql_server.flxsql.id
	auto_pause_delay_in_minutes = 60
	collation                   = "SQL_Latin1_General_CP1_CI_AS"
	max_size_gb                 = 32
	sku_name                    = "GP_S_Gen5_1"
	storage_account_type        = "Local"
	min_capacity                = 0.5
	tags                        = local.tags
}