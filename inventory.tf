resource "local_file" "instances_file" {
    filename = "../provisioners/${var.instances_inventory_file}"
    content = templatefile("../templates/inventory.tpl",
        {
            re_master_ip = "${azurerm_public_ip.fixedip.0.ip_address}"
            re_instance_hostnames = "${join("\n", (azurerm_public_ip.fixedip.*.name) )}"
            re_instance_ips = "${join("\n", (azurerm_public_ip.fixedip.*.ip_address) )}"
            re_node_ips = "${join("\n", slice( azurerm_public_ip.fixedip.*.ip_address, 1, length(azurerm_public_ip.fixedip.*.ip_address) ) )}"
            tester_ips = "${join("\n",(azurerm_linux_virtual_machine.tester-node.*.public_ip_address) )}"
            kafka_ips = "${join("\n",(azurerm_linux_virtual_machine.kafka-node.*.public_ip_address) )}"
            ssh_user = "${var.ssh-user}"
            cluster_size = "${var.node-count}"
            re_cluster_domain = "${var.cluster-name}.${var.cluster-base-domain}"
        })

    depends_on = [
        azurerm_public_ip.fixedip, azurerm_linux_virtual_machine.tester-node, azurerm_linux_virtual_machine.kafka-node
    ]
}
