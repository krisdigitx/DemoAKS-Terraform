terraform {
  required_version = ">= 1.3"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
  }
  backend "azurerm" {
      resource_group_name  = "devopsdemoxyz-dev-rg"
      storage_account_name = "tfstatetfstatedemodevxyz"
      container_name       = "tfstate"
      key                  = "terraform.tfstate"
  }
}

provider "azurerm" {
  features {}
}

# Reference to the current subscription.  Used when creating role assignments
data "azurerm_subscription" "current" {}

resource "random_pet" "rg" {
  length = 1
  prefix = var.name
}

# The main resource group for this deployment
resource "azurerm_resource_group" "default" {
  name     = "${random_pet.rg.id}-${var.environment}-rg"
  location = var.location
}



