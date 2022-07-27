terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.3.0"
    }
    azapi = {
      source  = "Azure/azapi"
      version = "0.4.0"
    }
  }
}

provider "azurerm" {
  features {}
}

provider "azapi" {
}

resource "azurerm_resource_group" "rg" {
  name     = "n4a-tf-sample"
  location = "eastus2"
}

resource "azurerm_public_ip" "pip" {
  name                = "n4a-tf-pip"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  allocation_method   = "Static"
  ip_version          = "IPv4"
  sku                 = "Standard"
}

resource "azurerm_network_security_group" "nsg" {
  name                = "n4a-tf-nsg"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
}

resource "azurerm_network_security_rule" "http" {
  name                        = "http"
  resource_group_name         = azurerm_resource_group.rg.name
  network_security_group_name = azurerm_network_security_group.nsg.name
  priority                    = 100
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "80"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
}

resource "azurerm_virtual_network" "vnet" {
  name                = "n4a-tf-vnet"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
}

resource "azapi_resource" "subnet-delegated" {
  type      = "Microsoft.Network/virtualNetworks/subnets@2021-08-01"
  name      = "delegated"
  parent_id = azurerm_virtual_network.vnet.id

  body = jsonencode({
    properties = {
      addressPrefix = "10.0.1.0/24"
      networkSecurityGroup = {
        id = azurerm_network_security_group.nsg.id
      }
      delegations = [
        {
          name = "NGINX.NGINXPLUS/nginxDeployments"
          properties = {
            serviceName = "NGINX.NGINXPLUS/nginxDeployments"
          }
        }
      ]
    }
  })
}

resource "azapi_resource" "nginx-deployment" {
  type      = "NGINX.NGINXPLUS/nginxDeployments@2021-05-01-preview"
  name      = "n4a-tf-deployment"
  parent_id = azurerm_resource_group.rg.id
  location  = azurerm_resource_group.rg.location

  body = jsonencode({
    sku = {
      name = "preview_Monthly_hjdtn7tfnxcy"
    }
    properties = {
      networkProfile = {
        frontEndIPConfiguration = {
          publicIPAddresses = [
            {
              id = azurerm_public_ip.pip.id
            }
          ]
        }
        networkInterfaceConfiguration = {
          subnetId = azapi_resource.subnet-delegated.id
        }
      }
    }
  })
}
