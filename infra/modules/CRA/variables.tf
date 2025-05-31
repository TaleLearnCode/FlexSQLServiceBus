variable "environment" {
  type        = string
  description = "The environment for which resources are being provisioned."
}

variable "allowed_environments" {
  type        = list(string)
  description = "List of environments where the role assignments should be created."
}

variable "principal_ids" {
  type        = list(string)
  description = "List of principal IDs to assign the role to."
}

variable "role_definition_name" {
  type        = string
  description = "The name of the role definition."
}

variable "scope" {
  type        = string
  description = "The scope to which the role assignment applies."
}
