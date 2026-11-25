resource "azurerm_sentinel_log_analytics_workspace_onboarding" "lab" {
  workspace_id = azurerm_log_analytics_workspace.lab.id
}

output "sentinel_onboarding_id" {
  value = azurerm_sentinel_log_analytics_workspace_onboarding.lab.id
}
