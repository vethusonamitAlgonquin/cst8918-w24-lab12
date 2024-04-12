# Configure the Terraform runtime requirements.
terraform {
  required_version = ">= 1.1.0"

  required_providers {
    # Azure Resource Manager provider and version
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0.2"
    }
  }
}

# Define providers and their config params
provider "azurerm" {
  # Leave the features block empty to accept all defaults
  features {}
}

variable "labelPrefix" {
  default     = "amit0004"
  type        = string
  description = "Your college username. This will form the beginning of various resource names."
}

variable "region" {
  default     = "westus3"
  type        = string
  description = "the region of the resources"
}


#resource group
resource "azurerm_resource_group" "rg" {
  name     = "${var.labelPrefix}-githubactions-rg"
  location = var.region
}

resource "azurerm_storage_account" "githubactions" {
  name                     = "${var.labelPrefix}githubactions"
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = azurerm_resource_group.rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  min_tls_version          = "TLS1_2"
}

resource "azurerm_storage_container" "tfstate" {
  name                  = "tfstate"
  storage_account_name  = azurerm_storage_account.githubactions.name
  container_access_type = "private"
}



output "resource_group_name" {
  value = azurerm_resource_group.rg.name
}

output "storage_account_name" {
  value = azurerm_storage_account.githubactions.name
}

output "container_name" {
  value = azurerm_storage_container.tfstate.name
}

output "primary_access_key" {
  value     = azurerm_storage_account.githubactions.primary_access_key
  sensitive = true
}