
resource "azurerm_resource_group_policy_assignment" "allowed_locations" {
  name                 = "zt-allowed-locations"
  display_name         = "ZT Lab - Allowed Locations"
  description          = "Restrict lab resources to Qatar Central."
  resource_group_id    = azurerm_resource_group.zt.id
  policy_definition_id = "/providers/Microsoft.Authorization/policyDefinitions/e56962a6-4747-49cd-b67b-bf8b01975c4c"

  enforce = true

  parameters = jsonencode({
    listOfAllowedLocations = {
      value = ["qatarcentral"]
    }
  })
}

resource "azurerm_resource_group_policy_assignment" "required_environment_tag" {
  name         = "zt-required-environment-tag"
  display_name = "ZT Lab - Require Environment Tag"
  description  = "Require Environment=Lab except for the approved Sentinel managed solution."

  not_scopes = [
    "${azurerm_resource_group.zt.id}/providers/Microsoft.OperationsManagement/solutions/SecurityInsights(law-zt-lab-dev)"
  ]
  resource_group_id    = azurerm_resource_group.zt.id
  policy_definition_id = "/providers/Microsoft.Authorization/policyDefinitions/1e30110a-5ceb-460c-a204-c1c3969c6d62"

  enforce = true

  parameters = jsonencode({
    tagName = {
      value = "Environment"
    }
    tagValue = {
      value = "Lab"
    }
  })
}

