# Terra Configuration
This directory (`terra`) hosts the files needed to run terragrunt to provision
a Kubernetes cluster on a CSP of your choice (presuming you configure it accordingly),
deploy the helm chart, and run helm test.

The directory structure is as follows:
```
terra
├── README.md
├── config
│   ├── terraform.tfstate
│   ├── terraform.tfstate.backup
│   └── terragrunt.hcl
└── modules
    ├── aks-cluster
    │   ├── main.tf
    │   ├── outputs.tf
    │   └── vars.tf
    └── api-svc
        ├── kubeconfig.tpl
        ├── main.tf
        └── vars.tf
```

## Instructions
### Prereqs
* Ensure you have Terragrunt installed locally.
    * If running on MacOS you can use `brew install terragrunt`
    * If running on Linux or Windows follow the [Official Installation docs](https://terragrunt.gruntwork.io/docs/getting-started/install/)
* Ensure you have Terraform installed locally.
    * If running on MacOS you can use `brew tap hashicorp/tap && brew install hashicorp/tap/terraform`
    * If running on Linux or Windows follow the [Official Installation docs](https://www.terraform.io/downloads)
* Ensure you have a text editor and a terminal.
* Ensure you have the necessary dependencies for your CSP installed.
    * For example, for Azure Provider requires:
        * An Azure account
        * Terraform CLI
        * Azure CLI
        * [Azure Provider Docs](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs)
    * For whatever provider you're using, follow the documentation and pre-reqs to hook into this automation.
    * List of common providers:
        * [Azure Provider Docs](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs)
        * [AWS Provider Docs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs)
        * [GCP Provider Docs](https://registry.terraform.io/providers/hashicorp/google/latest/docs)
        * [OCI Provider Docs](https://registry.terraform.io/providers/hashicorp/oraclepaas/latest/docs)
        * [Linode Provider Docs](https://registry.terraform.io/providers/linode/linode/latest/docs)

### Azure Specific Terraform
The below is a personal set of notes largely taken from [Azure Getting Started](https://learn.hashicorp.com/tutorials/terraform/azure-build?in=terraform/azure-get-started)
1. Create an Azure account
2. Install the Azure CLI through Homebrew
```
brew update && \
    brew install azure-cli
```
3. Login to account with Azure CLI
```
az login
```
4. Set account subscription ID from the JSON response after login.
```
az account set --subscription "<sub id>"
```
5. Setup a service account for TF to interact as.
```
az ad sp create-for-rbac --role="Contributor" --scopes="/subscriptions/<sub id>"
```
6. Set some env vars *gross*
```
export ARM_CLIENT_ID="<APPID_VALUE>"
export ARM_CLIENT_SECRET="<PASSWORD_VALUE>"
export ARM_SUBSCRIPTION_ID="<SUBSCRIPTION_ID>"
export ARM_TENANT_ID="<TENANT_VALUE>"
```
7. Run `terraform plan && terraform apply` to apply the configuration defined
inside the [modules](./modules) directory.
> Note:
> In a production setting, remote storage of state files would be
> mandatory. See [remote storage](https://learn.hashicorp.com/tutorials/terraform/azure-remote?in=terraform/azure-get-started)

8. Follow the instructions for deploying an AKS cluster from TF's site [here](https://learn.hashicorp.com/tutorials/terraform/aks?in=terraform/azure)

9. Get your kubeconfig if you want to locally connect via kubectl
Using az cli, run the following:
```
az account set --subscription <your sub>
az aks get-credentials --resource-group <resource_group_name>  --name demo-aks1
```

## Terragrunt
Terragrunt's intent is to keep things dry, such that you get to have a singular
terraform file for your module, and then get to parameterize and generate through terragrunt.

### Instructions
1. Navigate to the [./config](./config) folder.
2. Edit the [terragrunt.hcl](./config/terragrunt.hcl) file.
    1. Here you can configure your provider accordingly.
    > You may need to add a module based on your provider configuration. 
    > For example, you can define the provider itself in the `terragrunt.hcl` file and have it generated into
    > `provider.tf`; however, you may need to add specific resources in a new module
    > so that your provider is correctly leveraged. You will also have to provide whatever
    > authentication mechanisms are unique to your provider.
    > If you want to use your own provider, you'll want to change the module import
    > in [./api-svc/main.tf](./api-svc/main.tf) as well to import the  module
    > providing your Kubernetes cluster instead.
    >
    > The below is a list of common provider documents
    >    * [Azure Provider Docs](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs)
    >    * [AWS Provider Docs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs)
    >    * [GCP Provider Docs](https://registry.terraform.io/providers/hashicorp/google/latest/docs)
    >    * [OCI Provider Docs](https://registry.terraform.io/providers/hashicorp/oraclepaas/latest/docs)
    >    * [Linode Provider Docs](https://registry.terraform.io/providers/linode/linode/latest/docs)
3. If using a provider other than Azure, you must do the following:
    1. Navigate to the [./modules](./modules) directory.
    2. Add in a module with your specific module configuration.
    3. Import or override your module in [./modules/api-scv/main.tf](./modules/api-scv/main.tf)
    > See the comments in the file
    4. Update your configuration to pass the necessary vars through.
4. From inside the [./config](./config) directory, run the following command:
```
terragrunt run-all apply
```
5. Read the plan, and select `yes` if you're ready to go for it.
