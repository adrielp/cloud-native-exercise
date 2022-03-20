# Using the api-svc module which calls aks-cluster under the hood
terraform {
  source = "${get_repo_root()}/terra/modules//api-svc"
}

# Indicate what region to deploy the resources into and required providers
generate "provider" {
  path      = "provider.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<EOF
terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "~>2.99"
    }
    helm = {
      source = "hashicorp/helm"
      version = "~>2.4.1"
    }
    null = {
      source = "hashicorp/null"
      version = "~>3.1.1"
    }
  }
}

provider "azurerm" {
  features {}
}

provider "helm" {
  kubernetes {
    host = module.aks-cluster.host

    # Authentication values pulled from the aks-cluster module outputs.
    client_certificate     = base64decode(module.aks-cluster.client_certificate)
    client_key             = base64decode(module.aks-cluster.client_key)
    cluster_ca_certificate = base64decode(module.aks-cluster.cluster_ca_certificate)
  }
}
EOF
}

# Remote state location for Terragrunt
remote_state {
  # Setting local terraform state
  backend = "local"
  # Using current terragrunt file dir for simplicity
  config = {
    path = "${get_terragrunt_dir()}/terraform.tfstate"
  }
  generate = {
    path      = "backend.tf"
    if_exists = "overwrite_terragrunt"
  }
}

# Indicate the input values to use for the variables of the modules.
inputs = {

  # Need to use an absolute path here for importing when calling from terragrunt
  helm_chart_local_path = "${get_repo_root()}/api-svc/chart/api-svc"

  # Azure settings
  resource_group_name = "api-svc-azure-demo"
  location            = "centralus"
  vm_size             = "standard_l8s_v2"

  tags = {
    Terraform   = "true"
    Environment = "api-svc-azure-demo"
  }
}
