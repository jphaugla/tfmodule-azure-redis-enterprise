variable "location" {
  description = "The location where resources will be created"
  default     = null
}

variable "av_zone" {
  description = "A list of availability zones to use. Make sure they're valid for this location."
  default     = ["1", "2"]
}

variable "net-cidr" {
  description = "The CIDR blocks to be used in the network"
  type        = list(any)
  default     = ["10.0.11.0/24"]
}

variable "net-name" {
  description = "The name to be associated with the network"
  default     = null
}

variable "cluster-name" {
  description = "The domain name for the cluster (in front of the cluster-base-domain)."
  default = "jphaugla"
}

variable "cluster-base-domain" {
  description = "A base domain name you own. Helpful if it's managed by a zone file in Azure."
  default = "not-defined"
}

variable "cluster-base-resource-group" {
  description = "The resource group that contains the zone file for the cluster-base-domain."
  default = "not-defined"
}

variable "node-size" {
  description = "The Size of the VM to run for nodes."
  default     = "Standard_DS4_v2"
}

# NOTE that you can't change this without changing parts of the provisioning scripts.
variable "node-publisher" {
  description = "The owner of the image"
  default     = "RedHat"
}

variable "node-offer" {
  description = "The type of the image"
  default     = "RHEL"
}

variable "node-sku" {
  description = "The SKU of the image"
  default     = "7.9"
}

variable "node-version" {
  description = "The version of the image"
  default     = "latest"
}

variable "test-size" {
  description = "The Size of the VM to run for tester node."
  default     = "Standard_DS2_v2"
}

# NOTE that you can't change this without changing parts of the provisioning scripts.
variable "test-publisher" {
  description = "The owner of the image"
  default     = "RedHat"
}

variable "test-offer" {
  description = "The type of the image"
  default     = "RHEL"
}

variable "test-sku" {
  description = "The SKU of the image"
  default     = "7.7"
}

variable "test-version" {
  description = "The version of the image"
  default     = "latest"
}

variable "subnet-count" {
  description = "The number of subnets to spin up"
  default     = null
}

variable "node-count" {
  description = "The number of Redis nodes to spin up"
  default     = 3
}


variable "join-count" {
  description = "The number of non-master re nodes"
  default     = 2
}

variable "tester-count" {
  description = "The number of Tester nodes to spin up"
  default     = 1
}

variable "kafka-count" {
  description = "The number of kafka nodes to spin up-really is 0 or 1"
  default     = 1
}

variable "common-tags" {
  description = "A map of the tags to use for the resources that are deployed"
  type        = map(any)
}

variable "ssh-user" {
  description = "The SSH User"
  default     = "redislabs"
}

variable "ssh-key" {
  description = "The SSH Public Key path"
}

variable "ssh-private-key" {
  description = "The SSH Private Key path"
}

variable "accelerated-networking" {
  description = "Enable Accelerated networking"
  default     = false
}

# Use this to determine what version of the software gets installed
variable "re-download-url" {
  description = "The download link for the redis enterprise software"
  default     = null
}

variable "allow-public-ssh" {
  description = "Allow SSH to be open to the public - disabled by default"
  default     = "0"
}

variable "open-nets" {
  type        = list(any)
  description = "CIDRs that will have access to everything"
  default     = []
}

variable "instances_inventory_file" {
    description = "Path and file name to send inventory details for ansible later."
    default = "inventory"
}

variable "ansible_verbosity_switch" {
    description = "Set the about of verbosity to pass through to the ansible playbook command. No additional verbosity by default. Example: -v or -vv or -vvv."
    default = ""
}
