terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=2.98.0"
    }
  }

  backend "azurerm" {
  }

  required_version = "= 1.1.7"
}

provider "azurerm" {
  features {
    api_management {
      purge_soft_delete_on_destroy = true
    }
  }
  skip_provider_registration = true
}
