##########################################################################################
resource "null_resource" "provision" {

    triggers = {
        always_run = "${timestamp()}"
    }

    provisioner "local-exec" {
        working_dir = "../provisioners/"
        command = "ansible-playbook -i '${var.instances_inventory_file}' --private-key ${var.ssh-private-key} playbook.yml ${var.ansible_verbosity_switch} -e 'S3_RE_BINARY=${var.re-download-url}'"
    }

    depends_on = [
azurerm_public_ip.fixedip,local_file.instances_file
    ]
}
