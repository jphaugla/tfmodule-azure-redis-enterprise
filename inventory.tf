data  "template_file" "instances" {
    template = file("../templates/inventory.tpl")
    
    vars = {
        re_master_ip = "${azurerm_public_ip.fixedip.0.ip_address}"
        re_instance_hostnames = "${azurerm_public_ip.fixedip.0.name}"
        re_node_ips = "${join("\n", slice( azurerm_public_ip.fixedip.*.ip_address, 1, length(azurerm_public_ip.fixedip.*.ip_address) ) )}"
        ssh_user = "${var.ssh-user}"
        cluster_size = "${var.node-count}"
        re_cluster_domain = "${var.cluster-name}.${var.cluster-base-domain}"
    }

    depends_on = [
azurerm_public_ip.fixedip	
    ]
}

resource "local_file" "instances_file" {
  content  = data.template_file.instances.rendered
  filename = "../provisioners/${var.instances_inventory_file}"
}
