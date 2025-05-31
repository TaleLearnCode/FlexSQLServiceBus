resource "azurerm_servicebus_topic" "this" {
	name                                    = var.name
	namespace_id                            = var.namespace_id
	duplicate_detection_history_time_window = var.duplicate_detection_history_time_window
	requires_duplicate_detection            = var.requires_duplicate_detection
	support_ordering                        = var.support_ordering
}

# -----------------------------------------------------------------------------
# Role Assignments
# -----------------------------------------------------------------------------

module "developer_role_assignment_sender" {
  source              = "../CRA"

  environment          = var.environment
  allowed_environments = ["sit", "dev"]  # Architects get "Azure Service Bus Data Sender" in SIT and DEV
  principal_ids        = var.developer_principal_ids
  role_definition_name = "Azure Service Bus Data Sender"
  scope                = azurerm_servicebus_topic.this.id
}


module "architect_role_assignment_sender" {
  source              = "../CRA"

  environment          = var.environment
  allowed_environments = ["sit", "dev", "qa"]  # Architects get "Azure Service Bus Data Sender" in SIT, DEV, and QA
  principal_ids        = var.architect_principal_ids
  role_definition_name = "Azure Service Bus Data Sender"
  scope                = azurerm_servicebus_topic.this.id
}