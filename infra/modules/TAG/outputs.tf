# #############################################################################
# Outputs
# #############################################################################

output "tags" {
  value = {
    Product     = var.product
    Criticality = var.criticality
    CostCenter  = "${var.cost_center}-${var.environment}"
    DR          = var.disaster_recovery
    Env         = var.environment
  }
}