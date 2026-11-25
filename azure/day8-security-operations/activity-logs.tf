data "azurerm_subscription" "current" {}

resource "azurerm_monitor_diagnostic_setting" "activity_logs" {
  name                       = "diag-zt-azure-activity"
  target_resource_id         = data.azurerm_subscription.current.id
  log_analytics_workspace_id = azurerm_log_analytics_workspace.lab.id

  dynamic "enabled_log" {
    for_each = toset([
      "Administrative",
      "Security",
      "Policy",
      "Alert",
      "ServiceHealth",
      "ResourceHealth",
      "Recommendation",
      "Autoscale"
    ])

    content {
      category = enabled_log.value
    }
  }
}
