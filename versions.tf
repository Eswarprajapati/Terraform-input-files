terraform {
  required_version = ">= 1.9.0, < 2.0.0"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "4.38.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "3.7.2"
    }
  }
}
provider "azurerm" {
  features {}
  # ARM_SUBSCRIPTION_ID and Azure CLI/OIDC supply authentication.
}
