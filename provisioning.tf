##########################################################################################
# ensure we can get to the node first
resource "null_resource" "remote-config" {
  count = var.node-count
  provisioner "remote-exec" {
    connection {
      user        = "redislabs"
      host        = element(azurerm_public_ip.fixedip.*.ip_address, count.index)
      private_key = file(var.ssh-private-key)
      agent       = true
    }
    inline = ["touch /tmp/itconnected"]
  }
  depends_on = [azurerm_public_ip.fixedip, null_resource.tester-inventory-setup, null_resource.ssh-setup]
}

###############################################################################
# Template Data
#data "template_file" "ansible_inventory" {
#  count    = var.node-count
#  template = "${file("${path.module}/inventory.tpl")}"
#  vars = {
#    host_ip  = element(azurerm_public_ip.fixedip.*.ip_address, count.index)
#    location = var.location
#    ncount   = count.index
#    master_ip  = element(azurerm_public_ip.fixedip.*.ip_address, 0)
#  }
#  depends_on = [azurerm_public_ip.fixedip, azurerm_linux_virtual_machine.redis-nodes]
#}
data "template_file" "ansible_tester_inventory" {
  template = "${file("${path.module}/inventory.tpl")}"
  vars = {
    host_ip  = element(azurerm_linux_virtual_machine.tester-node.*.public_ip_address, 0)
    location = var.location
    ncount   = 0
  }
  depends_on = [azurerm_linux_virtual_machine.tester-node]
}

data "template_file" "ssh_config" {
  template = "${file("${path.module}/ssh.tpl")}"
  vars = {
    location = var.location
  }
  depends_on = [azurerm_public_ip.fixedip]
}

###############################################################################
# Template Write
# resource "null_resource" "inventory-setup" {
#   count = var.node-count
#   provisioner "local-exec" {
#     command = "echo \"${element(data.template_file.ansible_inventory.*.rendered, count.index)}\" > /tmp/${var.location}_node_${count.index}.ini"
#   }
#   depends_on = [data.template_file.ansible_inventory]
# }

resource "null_resource" "tester-inventory-setup" {
  provisioner "local-exec" {
    command = "echo \"${element(data.template_file.ansible_tester_inventory.*.rendered, 1)}\" > /tmp/${var.location}_tester_node_app.ini"
  }
  depends_on = [data.template_file.ansible_tester_inventory]
}

resource "null_resource" "ssh-setup" {
  provisioner "local-exec" {
    command = "echo \"${data.template_file.ssh_config.rendered}\" > /tmp/${var.location}_node.cfg"
  }
  depends_on = [data.template_file.ssh_config]
}

###############################################################################
# Run some ansible
#resource "null_resource" "ansible-run" {
#  count = var.node-count
#  provisioner "local-exec" {
#    command = "ansible-playbook ${path.module}/ansible/playbook.yml --private-key ${var.ssh-private-key} -i /tmp/${var.location}_node_${count.index}.ini --become -e 'S3_RE_BINARY=${var.re-download-url}'" 
#  }
#  depends_on = [null_resource.remote-config]
#}

 resource "null_resource" "ansible-tester-run" {
   count = 1
   provisioner "local-exec" {
     command = "ansible-playbook ${path.module}/ansible/testernode.yml --private-key ${var.ssh-private-key} -i /tmp/${var.location}_tester_node_app.ini --become" 
   }
  depends_on = [null_resource.remote-config]
}

resource "null_resource" "provision" {

    triggers = {
        always_run = "${timestamp()}"
    }

    provisioner "local-exec" {
        working_dir = "../provisioners/"
        command = "ansible-playbook -i '${var.instances_inventory_file}' --private-key ${var.ssh-private-key} playbook.yml ${var.ansible_verbosity_switch} -e 'S3_RE_BINARY=${var.re-download-url}'"
    }

    depends_on = [
azurerm_public_ip.fixedip
    ]
}
