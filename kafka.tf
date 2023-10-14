resource "azurerm_linux_virtual_machine" "kafka-node" {
  count                 = var.kafka-count
  name                  = "${local.net-name}-kafka"
  location              = var.location
  resource_group_name   = azurerm_resource_group.resource.name
  network_interface_ids = ["${element(azurerm_network_interface.kafkanic.*.id, count.index)}"]
  size               = var.test-size
  admin_username     = var.ssh-user

  os_disk {
    name              = "${local.net-name}-kafka"
    caching           = "ReadWrite"
    storage_account_type  = "Premium_LRS"
  }

  source_image_reference {
    publisher = var.test-publisher
    offer     = var.test-offer
    sku       = var.test-sku
    version   = var.test-version
  }

  admin_ssh_key {
    username = var.ssh-user
    public_key = file(var.ssh-key)
  }

  disable_password_authentication = true
  tags                             = merge({ Name = "${local.net-name}-kafka" }, var.common-tags)
}
