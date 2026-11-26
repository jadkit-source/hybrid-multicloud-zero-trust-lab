resource "azurerm_resource_group_template_deployment" "sentinel_connection" {
  name                = "deploy-zt-sentinel-connection"
  resource_group_name = data.azurerm_resource_group.lab.name
  deployment_mode     = "Incremental"

  template_content = jsonencode({
    "$schema"      = "https://schema.management.azure.com/schemas/2019-04-01/deploymentTemplate.json#"
    contentVersion = "1.0.0.0"

    resources = [
      {
        type       = "Microsoft.Web/connections"
        apiVersion = "2016-06-01"
        name       = "azuresentinel-zt-triage"
        location   = azurerm_log_analytics_workspace.lab.location
        kind       = "V1"

        tags = {
          Environment = "Lab"
          Purpose     = "ZeroTrust-SOAR"
        }

        properties = {
          displayName           = "ZT Sentinel Managed Identity"
          parameterValueType    = "Alternative"
          customParameterValues = {}

          api = {
            id = "/subscriptions/${data.azurerm_subscription.current.subscription_id}/providers/Microsoft.Web/locations/${azurerm_log_analytics_workspace.lab.location}/managedApis/azuresentinel"
          }
        }
      }
    ]
  })

  depends_on = [
    azurerm_logic_app_workflow.incident_triage
  ]
}
