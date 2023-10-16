# tfmodule-azure-redis-enterprise

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

Public Azure Instance and Network setup


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
