locals {
  detection_rules = {
    policy_denial = {
      name         = "zt-001-policy-denial"
      display_name = "ZT-001 - Azure Policy Denial"
      severity     = "Low"
      description  = "Detects resource operations denied by Azure Policy."
      query        = <<-KQL
        AzureActivity
        | where ingestion_time() > ago(5m)
        | where OperationNameValue =~ "Microsoft.Authorization/policies/deny/action"
        | extend TargetResourceId = iff(isempty(ResourceId), _ResourceId, ResourceId)
        | project TimeGenerated, Caller, TargetResourceId,
                  ActivityStatusValue, CorrelationId
      KQL
    }

    rbac_change = {
      name         = "zt-002-rbac-modification"
      display_name = "ZT-002 - Azure RBAC Modification"
      severity     = "Medium"
      description  = "Detects successful Azure RBAC assignment changes."
      query        = <<-KQL
        AzureActivity
        | where ingestion_time() > ago(5m)
        | where OperationNameValue in~ (
            "Microsoft.Authorization/roleAssignments/write",
            "Microsoft.Authorization/roleAssignments/delete"
          )
        | where ActivityStatusValue =~ "Success"
        | extend TargetResourceId = iff(isempty(ResourceId), _ResourceId, ResourceId)
        | project TimeGenerated, Caller, TargetResourceId,
                  OperationNameValue, CorrelationId
      KQL
    }

    nsg_change = {
      name         = "zt-003-nsg-modification"
      display_name = "ZT-003 - NSG Rule Modification"
      severity     = "Medium"
      description  = "Detects successful network security rule changes."
      query        = <<-KQL
        AzureActivity
        | where ingestion_time() > ago(5m)
        | where OperationNameValue in~ (
            "Microsoft.Network/networkSecurityGroups/securityRules/write",
            "Microsoft.Network/networkSecurityGroups/securityRules/delete"
          )
        | where ActivityStatusValue =~ "Success"
        | extend TargetResourceId = iff(isempty(ResourceId), _ResourceId, ResourceId)
        | project TimeGenerated, Caller, TargetResourceId,
                  OperationNameValue, CorrelationId
      KQL
    }
  }
}

resource "azurerm_sentinel_alert_rule_scheduled" "detections" {
  for_each = local.detection_rules

  name                       = each.value.name
  log_analytics_workspace_id = azurerm_log_analytics_workspace.lab.id
  display_name               = each.value.display_name
  description                = each.value.description
  severity                   = each.value.severity
  query                      = each.value.query

  enabled           = true
  query_frequency   = "PT5M"
  query_period      = "PT30M"
  trigger_operator  = "GreaterThan"
  trigger_threshold = 0

  depends_on = [
    azurerm_sentinel_log_analytics_workspace_onboarding.lab
  ]
}
