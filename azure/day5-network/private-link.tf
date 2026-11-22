
variable "deploy_private_link" {
  description = "Deploy billable Private Link resources"
  type        = bool
  default     = false
}

resource "azurerm_private_dns_zone" "keyvault" {
  count = var.deploy_private_link ? 1 : 0

  name                = "privatelink.vaultcore.azure.net"
  resource_group_name = azurerm_resource_group.zt.name

  tags = local.tags
}

resource "azurerm_private_dns_zone_virtual_network_link" "keyvault" {
  count = var.deploy_private_link ? 1 : 0

  name                  = "link-zt-vnet"
  resource_group_name   = azurerm_resource_group.zt.name
  private_dns_zone_name = azurerm_private_dns_zone.keyvault[0].name
  virtual_network_id    = azurerm_virtual_network.zt.id
  registration_enabled  = false
}

resource "azurerm_private_endpoint" "keyvault" {
  count = var.deploy_private_link ? 1 : 0

  name                = "pe-zt-keyvault"
  location            = local.location
  resource_group_name = azurerm_resource_group.zt.name
  subnet_id           = azurerm_subnet.private_endpoint.id

  private_service_connection {
    name                           = "psc-zt-keyvault"
    private_connection_resource_id = azurerm_key_vault.zt.id
    is_manual_connection           = false
    subresource_names              = ["vault"]
  }

  private_dns_zone_group {
    name = "default"

    private_dns_zone_ids = [
      azurerm_private_dns_zone.keyvault[0].id
    ]
  }

  tags = local.tags
}
