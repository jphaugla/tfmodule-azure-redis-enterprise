resource "azurerm_linux_virtual_machine" "redis-nodes" {
  count                 = var.node-count
  name                  = "${local.net-name}-${count.index}"
  location              = var.location
  resource_group_name   = azurerm_resource_group.resource.name
  network_interface_ids = ["${element(azurerm_network_interface.nic.*.id, count.index)}"]
  size               = var.node-size
  admin_username     = var.ssh-user

  os_disk {
    name              = "${local.net-name}-${count.index}"
    caching           = "ReadWrite"
    storage_account_type  = "Premium_LRS"
  }

  source_image_reference {
    publisher = var.node-publisher
    offer     = var.node-offer
    sku       = var.node-sku
    version   = var.node-version
  }

  admin_ssh_key {
    username = var.ssh-user
    public_key = file(var.ssh-key)
  }

  disable_password_authentication = true
  tags                             = merge({ Name = "${local.net-name}-${count.index}" }, var.common-tags)
}
