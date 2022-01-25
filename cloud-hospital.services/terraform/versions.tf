terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 2.93"
    }
  }

  required_version = ">= 1.1.4"
}
