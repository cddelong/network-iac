terraform {
#  backend "local" {
#    path = "./state/terraform.tfstate"
#  }
  cloud {
    organization = "cdelong"

    workspaces {
      name = "network-iac"
    }
  }
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 2.62.1"
    }
  }
  required_version = ">= 1.2.6"
}
