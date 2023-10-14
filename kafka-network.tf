resource "azurerm_network_interface" "kafkanic" {
  count                         = var.kafka-count
  enable_accelerated_networking = var.accelerated-networking
  name                          = "${local.net-name}-kafka-${count.index}"
  location                      = var.location
  resource_group_name           = azurerm_resource_group.resource.name
  tags                          = merge({ Name = "${local.net-name}-${count.index}" }, var.common-tags)

  ip_configuration {
    name                          = "${local.net-name}-kafka-${count.index}"
    subnet_id                     = element(azurerm_subnet.subnet.*.id, count.index)
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = element(azurerm_public_ip.kafka.*.id, count.index)
  }
}

resource "azurerm_network_interface_security_group_association" "sg2kafkanic" {
  count                     =var.kafka-count
  network_interface_id      = element(azurerm_network_interface.kafkanic.*.id, count.index)
  network_security_group_id = azurerm_network_security_group.sg.id
}


resource "azurerm_public_ip" "kafka" {
  count               = var.kafka-count
  name                = "${local.net-name}-kafka-public-ip"
  resource_group_name = azurerm_resource_group.resource.name
  location            = var.location
  allocation_method   = "Dynamic"
  tags                = merge({ Name = "${local.net-name}-kafka-public-ip" }, var.common-tags)
}
