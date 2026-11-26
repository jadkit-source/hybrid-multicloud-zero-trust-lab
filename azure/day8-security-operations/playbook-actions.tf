resource "azurerm_logic_app_trigger_custom" "sentinel_incident" {
  name         = "Microsoft_Sentinel_incident"
  logic_app_id = azurerm_logic_app_workflow.incident_triage.id

  body = jsonencode({
    type = "ApiConnectionWebhook"

    inputs = {
      body = {
        callback_url = "@{listCallbackUrl()}"
      }

      host = {
        connection = {
          name = "@parameters('$connections')['azuresentinel']['connectionId']"
        }
      }

      path = "/incident-creation"
    }
  })

  depends_on = [
    azurerm_resource_group_template_deployment.sentinel_connection
  ]
}

resource "azurerm_logic_app_action_custom" "triage_comment" {
  name         = "Add_investigation_comment"
  logic_app_id = azurerm_logic_app_workflow.incident_triage.id

  body = jsonencode({
    type = "Http"

    inputs = {
      method = "PUT"
      uri    = "@{concat('https://management.azure.com', triggerBody()?['object']?['id'], '/comments/', guid(), '?api-version=2024-03-01')}"

      authentication = {
        type     = "ManagedServiceIdentity"
        audience = "https://management.azure.com/"
      }

      body = {
        properties = {
          message = "Zero Trust SOAR: Automated triage initiated. Verify the change against approved requests and investigate the affected resource before remediation."
        }
      }
    }

    runAfter = {}
  })

  depends_on = [
    azurerm_logic_app_trigger_custom.sentinel_incident,
    azurerm_role_assignment.playbook_responder
  ]
}
