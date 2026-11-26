resource "azurerm_logic_app_workflow" "incident_triage" {
  name                = "la-zt-incident-triage"
  location            = azurerm_log_analytics_workspace.lab.location
  resource_group_name = data.azurerm_resource_group.lab.name

  workflow_parameters = {
    "$connections" = jsonencode({
      type         = "Object"
      defaultValue = {}
    })
  }

  parameters = {
    "$connections" = jsonencode({
      azuresentinel = {
        connectionId   = "${data.azurerm_resource_group.lab.id}/providers/Microsoft.Web/connections/azuresentinel-zt-triage"
        connectionName = "azuresentinel-zt-triage"
        id             = "/subscriptions/${data.azurerm_subscription.current.subscription_id}/providers/Microsoft.Web/locations/${azurerm_log_analytics_workspace.lab.location}/managedApis/azuresentinel"

        connectionProperties = {
          authentication = {
            type = "ManagedServiceIdentity"
          }
        }
      }
    })
  }

  identity {
    type = "SystemAssigned"
  }

  tags = {
    Environment = "Lab"
    Purpose     = "ZeroTrust-SOAR"
  }
}

resource "azurerm_role_assignment" "playbook_responder" {
  scope                = azurerm_log_analytics_workspace.lab.id
  role_definition_name = "Microsoft Sentinel Responder"
  principal_id         = azurerm_logic_app_workflow.incident_triage.identity[0].principal_id
}
