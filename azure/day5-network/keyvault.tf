
# Current Azure identity and subscription
data "azurerm_client_config" "current" {}

# Unique Key Vault name suffix
resource "random_string" "kv_suffix" {
  length  = 8
  upper   = false
  special = false
}

resource "azurerm_key_vault" "zt" {
  name = "kv-ztlab-${random_string.kv_suffix.result}"

  location            = azurerm_resource_group.zt.location
  resource_group_name = azurerm_resource_group.zt.name
  tenant_id           = data.azurerm_client_config.current.tenant_id

  sku_name = "standard"

  # Identity authorization
  rbac_authorization_enabled = true

  # Network security
  public_network_access_enabled = false

  # Recovery
  soft_delete_retention_days = 7

  # Disposable lab setting; production should enable this
  purge_protection_enabled = false

  tags = local.tags
}

output "key_vault_name" {
  value = azurerm_key_vault.zt.name
}

output "key_vault_uri" {
  value = azurerm_key_vault.zt.vault_uri
}
