variable "sentinel_service_principal_object_id" {
  description = "Object ID of Azure Security Insights service principal"
  type        = string
}

resource "azurerm_role_assignment" "sentinel_playbook_invoker" {
  scope                = data.azurerm_resource_group.lab.id
  role_definition_name = "Microsoft Sentinel Automation Contributor"
  principal_id         = var.sentinel_service_principal_object_id
}
