provider "azurerm" {
}

module "azure" {
  source           = "../"
  location         = "eastus" # broken on purpose so you can't create resoruces
  allow-public-ssh = 1
  ssh-key          = "~/.ssh/id_rsa_azure.pub"
  ssh-private-key  = "~/.ssh/id_rsa_azure"
  open-nets        = ["10.0.0.12/32"]
  common-tags = {
    Owner       = "jason.haugland@redis.com",
    Config      = "terraform",
    Environment = "tf-test"
  }
  cluster-base-domain = "jphaugla.demo-rlec.redislabs.com"
  cluster-name = "jph"
  node-size = "Standard_DS4_v2"
  node-count = 3
  cluster-base-resource-group = "jphaugla-dns"
  node-publisher = "RedHat"
  node-offer     = "RHEL"
  node-sku       = "7-RAW"
  node-version   = "latest"
  test-size = "Standard_DS4_v2"
  tester-count     = 1
  test-publisher = "Canonical"
  test-offer     = "0001-com-ubuntu-server-jammy"
  test-sku       = "22_04-lts-gen2"
  test-version   = "latest"
  kafka-count    = 1
  re-download-url = "https://s3.amazonaws.com/redis-enterprise-software-downloads/6.4.2/redislabs-6.4.2-94-rhel7-x86_64.tar"
}
