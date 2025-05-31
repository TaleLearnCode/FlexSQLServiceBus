# #############################################################################
# Variables
# #############################################################################

variable "product" {
  type        = string
  description = "The product or service that the resources are being created for."
}

variable "criticality" {
  type        = string
  description = "The business impact of the resource or supported workload. Valid values are Low, Medium, High, Business Unit Critical, and Mission Critical."
}

variable "cost_center" {
  type        = string
  description = "Accounting cost center associated with the resources."
}

variable "disaster_recovery" {
  type        = string
  description = "Business criticality of the application, workload, or service. Valid values are Dev, Essential, Critical, Mission Critical."
}

variable "environment" {
  type        = string
  description = "The Azure environment where the resources are deployed."
}