# #############################################################################
# Tags
# #############################################################################

locals {
  tags = module.tags.tags
}

variable "tag_product" {
  type        = string
  default     = "Flex Consumption SQL Trigger"
  description = "The product or service that the reosurces are being created for."
}

variable "tag_criticality" {
  type        = string
  description = "The business impact of the resource or supported workload. Valid values are Low, Medium, High, Business Unit Critical, and Mission Critical."
}

variable "tag_cost_center" {
  type        = string
  default     = "FLX-SQL"
  description = "Accounting cost center associated with the resources."
}

variable "tag_disaster_recovery" {
  type        = string
  description = "Business criticality of the application, workfload, or service.. Valid values are Dev, Essential, Critical, Mission Critical."
}

module "tags" {
  source  = ".//modules/TAG"

  product           = var.tag_product
  criticality       = var.tag_criticality
  cost_center       = "${var.tag_cost_center}-${var.environment}"
  disaster_recovery = var.tag_disaster_recovery
  environment       = var.environment
}