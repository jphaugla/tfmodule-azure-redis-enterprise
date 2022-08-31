locals {
  full_zone = (var.cluster-base-resource-group == null ? 1 : 0)
  cluster-name = var.cluster-name
  cluster-base-domain = var.cluster-base-domain
  cluster-base-resource-group = var.cluster-base-resource-group
  username= var.username
  password= var.password
}

# If there's no upstream record to update, create one
resource "azurerm_dns_zone" "base" {
  count               = local.full_zone
  name                = local.cluster-base-domain
  resource_group_name = "${azurerm_resource_group.resource.name}"
}

resource "azurerm_dns_a_record" "fixedip" {
  count = var.node-count
  name = "ns${count.index}.${local.cluster-name}"
  zone_name           = local.cluster-base-domain
  resource_group_name  = "${(local.cluster-base-resource-group != null ? local.cluster-base-resource-group : azurerm_resource_group.resource.name)}"
  records =  [ "${element(data.azurerm_public_ip.fixedip.*.ip_address, count.index)}" ]
  # records = [ "${element(azurerm_network_interface.nic.*.private_ip_address, count.index)}" ]
  ttl                 = 300
}

# TODO - allow switching between public and private IP addressing in DNS
resource "azurerm_dns_ns_record" "fixedip" {
  count = var.node-count
  name                = "${local.cluster-name}"
  zone_name           = "${local.cluster-base-domain}"
  resource_group_name  = "${(local.cluster-base-resource-group != null ? local.cluster-base-resource-group : azurerm_resource_group.resource.name)}"
  ttl                 = 300
  # Has to have trailing periods on each record
  records = formatlist("%s.${local.cluster-base-domain}.", azurerm_dns_a_record.fixedip.*.name)
}
