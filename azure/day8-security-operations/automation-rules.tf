locals {
  automation_rules = {
    policy_denial = {
      name  = "a1000000-0000-4000-8000-000000000001"
      title = "ZT-001 - Governance Triage"
      tag   = "Governance"
      order = 100
    }

    rbac_change = {
      name  = "a1000000-0000-4000-8000-000000000002"
      title = "ZT-002 - Privileged Access Triage"
      tag   = "PrivilegedAccess"
      order = 110
    }

    nsg_change = {
      name  = "a1000000-0000-4000-8000-000000000003"
      title = "ZT-003 - Network Security Triage"
      tag   = "NetworkSecurity"
      order = 120
    }
  }
}

resource "azurerm_sentinel_automation_rule" "triage" {
  for_each = local.automation_rules

  name                       = each.value.name
  log_analytics_workspace_id = azurerm_log_analytics_workspace.lab.id
  display_name               = each.value.title
  order                      = each.value.order
  enabled                    = true

  triggers_on   = "Incidents"
  triggers_when = "Created"

  condition_json = jsonencode([
    {
      conditionType = "Property"
      conditionProperties = {
        propertyName = "IncidentRelatedAnalyticRuleIds"
        operator     = "Contains"
        propertyValues = [
          azurerm_sentinel_alert_rule_scheduled.detections[each.key].id
        ]
      }
    }
  ])

  action_incident {
    order = 1
    labels = [
      each.value.tag,
      "TriageRequired"
    ]
  }

  dynamic "action_playbook" {
    for_each = each.key == "policy_denial" ? [1] : []

    content {
      order        = 2
      logic_app_id = azurerm_logic_app_workflow.incident_triage.id
    }
  }

  depends_on = [
    azurerm_role_assignment.sentinel_playbook_invoker,
    azurerm_logic_app_trigger_custom.sentinel_incident,
    azurerm_logic_app_action_custom.triage_comment
  ]
}

