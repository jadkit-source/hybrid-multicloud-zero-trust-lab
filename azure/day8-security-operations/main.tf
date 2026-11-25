terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.0"
    }
  }
}

provider "azurerm" {
  features {}
}

data "azurerm_resource_group" "lab" {
  name = "rg-zt-lab-dev"
}

resource "azurerm_log_analytics_workspace" "lab" {
  name                = "law-zt-lab-dev"
  location            = data.azurerm_resource_group.lab.location
  resource_group_name = data.azurerm_resource_group.lab.name

  sku               = "PerGB2018"
  retention_in_days = 30
  daily_quota_gb    = 0.1

  local_authentication_enabled    = false
  allow_resource_only_permissions = false
  internet_ingestion_enabled      = true
  internet_query_enabled          = true

  tags = {
    Environment = "Lab"
    Project     = "Hybrid-MultiCloud-ZeroTrust"
    ManagedBy   = "Terraform"
  }
}

output "workspace_resource_id" {
  value = azurerm_log_analytics_workspace.lab.id
}

output "workspace_name" {
  value = azurerm_log_analytics_workspace.lab.name
}

