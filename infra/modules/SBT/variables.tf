variable "environment" {
  type        = string
  description = "The environment for which resources are being provisioned."
}

variable "name" {
	type        = string
	description = "The name of the Service Bus Topic."
}

variable "namespace_id" {
	description = "The ID of the Service Bus Namespace where the topic will be created."
	type        = string
}

variable "duplicate_detection_history_time_window" {
	description = "The duration of the duplicate detection history for the topic."
	type        = string
	default     = "PT10M"	
}

variable "requires_duplicate_detection" {
	description = "Indicates whether the topic requires duplicate detection."
	type        = bool
	default     = false
}

variable "support_ordering" {
	description = "Indicates whether the topic supports ordering."
	type        = bool
	default     = false
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