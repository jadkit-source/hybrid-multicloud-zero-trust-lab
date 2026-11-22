terraform {
  required_version = ">= 1.5.0"


  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.0"
    }

    random = {
      source  = "hashicorp/random"
      version = "~> 3.0"
    }
  }

}

provider "azurerm" {
  features {}
  subscription_id = "a96be5d9-d081-44e3-9f17-7e577d13b35e"
}

locals {
  location = "qatarcentral"

  tags = {
    Environment = "Lab"
    Project     = "ZeroTrust"
    ManagedBy   = "Terraform"
  }
}

resource "azurerm_resource_group" "zt" {
  name     = "rg-zt-lab-dev"
  location = local.location
  tags     = local.tags
}

resource "azurerm_virtual_network" "zt" {
  name                = "vnet-zt-lab"
  location            = local.location
  resource_group_name = azurerm_resource_group.zt.name
  address_space       = ["10.50.0.0/16"]
  tags                = local.tags
}

resource "azurerm_subnet" "workload" {
  name                            = "snet-workload"
  resource_group_name             = azurerm_resource_group.zt.name
  virtual_network_name            = azurerm_virtual_network.zt.name
  address_prefixes                = ["10.50.1.0/24"]
  default_outbound_access_enabled = false
}

resource "azurerm_subnet" "private_endpoint" {
  name                              = "snet-private-endpoint"
  resource_group_name               = azurerm_resource_group.zt.name
  virtual_network_name              = azurerm_virtual_network.zt.name
  address_prefixes                  = ["10.50.2.0/24"]
  default_outbound_access_enabled   = false
  private_endpoint_network_policies = "Enabled"
}

resource "azurerm_network_security_group" "workload" {
  name                = "nsg-zt-workload"
  location            = local.location
  resource_group_name = azurerm_resource_group.zt.name
  tags                = local.tags

  security_rule {
    name                       = "Deny-Internet-Inbound"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Deny"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "Internet"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "Deny-VNet-Inbound"
    priority                   = 200
    direction                  = "Inbound"
    access                     = "Deny"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "VirtualNetwork"
    destination_address_prefix = "*"
  }


  security_rule {
    name                       = "Deny-PrivateEndpoint-Outbound"
    priority                   = 300
    direction                  = "Outbound"
    access                     = "Deny"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "10.50.2.0/24"
  }

  security_rule {
    name                       = "Deny-Internet-Outbound"
    priority                   = 310
    direction                  = "Outbound"
    access                     = "Deny"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "Internet"
  }
}

resource "azurerm_subnet_network_security_group_association" "workload" {
  subnet_id                 = azurerm_subnet.workload.id
  network_security_group_id = azurerm_network_security_group.workload.id
}

resource "azurerm_network_security_group" "private_endpoint" {
  name                = "nsg-zt-private-endpoint"
  location            = local.location
  resource_group_name = azurerm_resource_group.zt.name
  tags                = local.tags
}

resource "azurerm_subnet_network_security_group_association" "private_endpoint" {
  subnet_id                 = azurerm_subnet.private_endpoint.id
  network_security_group_id = azurerm_network_security_group.private_endpoint.id
}

output "resource_group_name" {
  value = azurerm_resource_group.zt.name
}

output "vnet_id" {
  value = azurerm_virtual_network.zt.id
}
