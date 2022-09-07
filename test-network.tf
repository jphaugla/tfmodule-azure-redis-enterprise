resource "azurerm_network_interface" "appnic" {
  enable_accelerated_networking = var.accelerated-networking
  name                          = "${local.net-name}-app"
  location                      = var.location
  resource_group_name           = azurerm_resource_group.resource.name
  tags                          = merge({ Name = "${local.net-name}" }, var.common-tags)

  ip_configuration {
    name                          = "${local.net-name}-app"
    subnet_id                     = element(azurerm_subnet.subnet.*.id, 1)
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.dynamic.id
  }
}

resource "azurerm_network_interface_security_group_association" "sg2appnic" {
  network_interface_id      = azurerm_network_interface.appnic.id
  network_security_group_id = azurerm_network_security_group.sg.id
}


resource "azurerm_public_ip" "dynamic" {
  name                = "${local.net-name}-app-public-ip"
  resource_group_name = azurerm_resource_group.resource.name
  location            = var.location
  allocation_method   = "Dynamic"
  tags                = merge({ Name = "${local.net-name}-app-public-ip" }, var.common-tags)
}
