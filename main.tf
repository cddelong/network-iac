resource "azurerm_resource_group" "hub" {
  name     = var.hub-rg-name
  location = var.region
}

resource "azurerm_virtual_network" "hub" {
  name                = var.hub-vnet-name
  location            = azurerm_resource_group.hub.location
  resource_group_name = azurerm_resource_group.hub.name
  address_space       = var.hub-cidr
}

resource "azurerm_virtual_wan" "hub" {
  name                = var.hub-vwan-name
  resource_group_name = azurerm_resource_group.hub.name
  location            = azurerm_resource_group.hub.location
}

resource "azurerm_virtual_hub" "hub" {
  name                = var.hub-vhub-name
  resource_group_name = azurerm_resource_group.hub.name
  location            = azurerm_resource_group.hub.location
  virtual_wan_id      = azurerm_virtual_wan.hub.id
  address_prefix      = var.vhub-cidr
}

resource "azurerm_vpn_server_configuration" "hub" {
  name                     = var.hub-vpn-config-name
  resource_group_name      = azurerm_resource_group.hub.name
  location                 = azurerm_resource_group.hub.location
  vpn_authentication_types = ["AAD"]
  vpn_protocols = ["OpenVPN"]

  azure_active_directory_authentication {
    audience = "41b23e61-6c1e-4545-b367-cd054e0ed4b4"
    issuer = "https://sts.windows.net/${var.aad-tenant}/"
    tenant = "https://login.microsoftonline.com/${var.aad-tenant}/"
  }

}
resource "azurerm_point_to_site_vpn_gateway" "hub" {
  name                        = var.hub-vpn-gateway-name
  location                    = azurerm_resource_group.hub.location
  resource_group_name         = azurerm_resource_group.hub.name
  virtual_hub_id              = azurerm_virtual_hub.hub.id
  vpn_server_configuration_id = azurerm_vpn_server_configuration.hub.id
  scale_unit                  = 1
  connection_configuration {
    name = "hub-gateway-config"

    vpn_client_address_pool {
      address_prefixes = [
        var.hub-p2s-cidr
      ]
    }
  }
}