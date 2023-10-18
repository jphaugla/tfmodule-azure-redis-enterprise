# tfmodule-azure-redis-enterprise

This github uses anisble and terraform to create a full redis cluster of a specified number of nodes.  Optionally, additional one node tiers are available:  cassandra, ubuntu application node, and kafka node.

## Prerequisites 

* [azure-cli](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli-apt?view=azure-cli-latest)
* [tfenv](https://github.com/tfutils/tfenv)

## Initialize Azure Credentials

```BASH
az login
```

## Links
[installing, configuring, running confluent platform](https://docs.confluent.io/platform/current/installation/installing_cp/deb-ubuntu.html)

## Module usage (Basic)

Public Azure Instance and Network setup.  Note the count variables:

* node-count:       number of redis nodes (3 is most common)
* cassandra-count:  number of cassandra nodes (really just 1 or 0)
* tester-count:     number of application node (really just 1 or 0)

To allow access from local PC instigating the terraform/ansible, set the my-ip variable.  This allows connectivity to redis and cassandra ports from the instigating laptop IP address.  Easiest way to get this Azure public IP address is using the Azure portal.  Go to an existing security rule in the portal and use the *My IP address* option to see local desktop IP address to put in to the my-ip variable.
![myip](images/MyIPAddress.png)

## Module usage (More advanced)

```
module "azure-redis-enterprise" {
  source       = "git@github.com:Redislabs-Solution-Architects/tfmodule-azure-redis-enterprise.git"
  cluster-name = "terraform-test-1.azure.example.com"
  location     = "uswest2"
  common-tags = {
    Owner       = "Ken_Watanabe@example.com",
    Config      = "terraform",
    Environment = "tf-test"
  }
}

```

From the `test` folder, update the `main.tf` file with the correct parameters for your environment.

Run
```bash
terraform init
```

```bash
terraform plan
```

```bash
terraform apply
```

To tear it all down:
```bash
terraform destroy
```
