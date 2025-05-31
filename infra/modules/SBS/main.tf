resource "azurerm_servicebus_subscription" "this" {
	name                                      = var.name
	topic_id                                  = var.topic_id
	max_delivery_count                        = var.PodsListUpdated_max_delivery_count
	default_message_ttl                       = var.PodsListUpdated_default_message_ttl
	lock_duration                             = var.PodsListUpdated_lock_duration
	dead_lettering_on_message_expiration      = var.PodsListUpdated_dead_lettering_on_message_expiration
	dead_lettering_on_filter_evaluation_error = var.PodsListUpdated_dead_lettering_on_filter_evaluation_error
	batched_operations_enabled                = var.PodsListUpdated_batched_operations_enabled
	requires_session                          = var.PodsListUpdated_requires_session
	status                                    = var.PodsListUpdated_status
}

# -----------------------------------------------------------------------------
# Role Assignments
# -----------------------------------------------------------------------------

module "developer_role_assignment_receiver" {
  source              = "../CRA"

  environment          = var.environment
  allowed_environments = ["sit", "dev", "qa"]  # Architects get "Azure Service Bus Data Receiver" in SIT and DEV
  principal_ids        = var.developer_principal_ids
  role_definition_name = "Azure Service Bus Data Receiver"
  scope                = azurerm_servicebus_subscription.this.id
}


module "architect_role_assignment_receiver" {
  source              = "../CRA"

  environment          = var.environment
  allowed_environments = ["sit", "dev", "qa", "e2e"]  # Architects get "Azure Service Bus Data Receiver" in SIT, DEV, QA, and E2E
  principal_ids        = var.architect_principal_ids
  role_definition_name = "Azure Service Bus Data Receiver"
  scope                = azurerm_servicebus_subscription.this.id
}

module "tester_role_assignment_receiver" {
  source              = "../CRA"

  environment          = var.environment
  allowed_environments = ["sit", "dev", "qa"]  # Architects get "Azure Service Bus Data Receiver" in SIT, DEV, and QA
  principal_ids        = var.testers_principal_ids
  role_definition_name = "Azure Service Bus Data Receiver"
  scope                = azurerm_servicebus_subscription.this.id
}