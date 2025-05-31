variable "environment" {
  type        = string
  description = "The environment for which resources are being provisioned."
}

variable "name" {
	type        = string
	description = "The name of the Service Bus Topic Subscription."
}

variable "topic_id" {
	description = "The ID of the Service Bus Topic to which the subscription belongs."
	type        = string
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

variable "testers_principal_ids" {
	type        = list(string)
	description = "List of principal IDs for testers."
	default     = []
}

variable "PodsListUpdated_max_delivery_count" {
	description = "The maximum number of deliveries for a message before it is dead-lettered."
	type        = number
	default     = 10
}

variable "PodsListUpdated_default_message_ttl" {
	description = "The default time to live for messages in the subscription."
	type        = string
	default     = "P10675199DT2H48M5.4775807S" # This is the max value for a Service Bus subscription
}

variable "PodsListUpdated_lock_duration" {
	description = "The duration that the message is locked for processing."
	type        = string
	default     = "PT5M"
}

variable "PodsListUpdated_dead_lettering_on_message_expiration" {
	description = "Enable dead lettering on message expiration."
	type        = bool
	default     = false
}

variable "PodsListUpdated_dead_lettering_on_filter_evaluation_error" {
	description = "Enable dead lettering on filter evaluation error."
	type        = bool
	default     = false
}

variable "PodsListUpdated_batched_operations_enabled" {
	description = "Enable batched operations for the subscription."
	type        = bool
	default     = true
}

variable "PodsListUpdated_requires_session" {
	description = "Indicates whether the subscription requires sessions."
	type        = bool
	default     = false
}

variable "PodsListUpdated_status" {
	description = "The status of the subscription."
	type        = string
	default     = "Active"
}