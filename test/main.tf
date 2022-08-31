provider "azurerm" {
}

module "azure" {
  source           = "../"
  location         = "eastus" # broken on purpose so you can't create resoruces
  allow-public-ssh = 1
  open-nets        = ["10.0.0.12/32"]
  common-tags = {
    Owner       = "testown.owner@redis.com",
    Config      = "terraform",
    Environment = "tf-test"
  }
  cluster-base-domain = "somedomain.rrrrrr.com"
  cluster-name = "mycluster"
  cluster-base-resource-group = "undefined"
  username = "un@domain.com"
  password = "09a87sdfy"
  node-publisher = "RedHat"
  node-offer     = "RHEL"
  node-sku       = "7-RAW"
  node-version   = "latest"
  re-download-url = "https://s3.amazonaws.com/redis-enterprise-software-downloads/6.2.12/redislabs-6.2.12-68-rhel7-x86_64.tar"

}
