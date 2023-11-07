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
[Azure terraform provider](https://github.com/hashicorp/terraform-provider-azurerm)

## Module usage (Basic)

Public Azure Instance and Network setup.  Note the count variables:

* node-count:       number of redis nodes (3 is most common)
* cassandra-count:  number of cassandra nodes (really just 1 or 0)
* tester-count:     number of application nodes (really just 1 or 0)
* kafka-count:      number of kafka nodes (really just 1 or 0)

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

## Check out what is there

node addresses for cassandra and kafka, as well as the redis endpoints and passord are dumped as appropriately named text files in the directory [provisioners/temp](provisioners/temp)
### kafka node
Check out the kafka control panel by substituting the localhost with the ip found in [kafka_external_ip.txt](provisioners/temp/kafka_external_ip.txt) at http://localhost:9021
### cassandra
```bash
export CQLSH_HOST=<public ip from cassandra_external_ip.txt>
cqlsh
> describe keyspaces;
pageviews  system_auth         system_schema  system_views
system     system_distributed  system_traces  system_virtual_schema

>use pageviews;
>select * from views;
 viewtime | pageid  | userid
----------+---------+--------
   123791 | Page_66 | User_4
   619431 | Page_99 | User_5
   972821 | Page_20 | User_8
   437401 | Page_51 | User_4
    26941 | Page_39 | User_4
  1021611 | Page_62 | User_5
   564921 | Page_13 | User_2
   504541 | Page_23 | User_4
   247411 | Page_20 | User_6
   463431 | Page_70 | User_7
   733721 | Page_55 | User_6
   376961 | Page_75 | User_2
   726761 | Page_68 | User_8
   242211 | Page_22 | User_9
   271671 | Page_55 | User_4
   388351 | Page_85 | User_4
```

### redis
```bash
redis-cli -h <redis_external_endpoint.txt> -p <redis_port.txt> -a jasonrocks
6077) "pageviews:27061"
6078) "pageviews:65441"
6079) "pageviews:60781"
6080) "pageviews:3191"
6081) "pageviews:36801"
6082) "pageviews:33691"
6083) "pageviews:7971"
6084) "pageviews:24301"
6085) "pageviews:35591"
```
## Tech notes
* test/main.tf has the important parameters.  
* Other paramaters are available in variables.tf.
* A template file at templates/inventory.tpl maps connects terraform to ansible along with provisioning.tf
* Ansible is all in the provisioners directory using the playbook.yml file
* Each of the node groups (redis, tester, cassandra, kafka) have a separate role under the provisioners/role directory (cassandra-node, kafka-node, redis-enterprise, tester-node)
* Under each of these roles, a vars/main.yml file has variable flags to enable/disable processing
  * To eliminate all process on one of these node groups, best to set the node count to zero in test/main.tf
* Under each of these roles  a tasks/main.yml calls the required tasks to do the actual processing

To tear it all down:
NOTE:  on teardown, may see failures on delete of some azure components.  Re-running the destroy command will eventually be successful
```bash
terraform destroy
```
