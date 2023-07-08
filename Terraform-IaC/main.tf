terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=3.0.0"
    }
  }
}

# Configure the Microsoft Azure Provider
provider "azurerm" {
  features {}
}

data "azurerm_resource_group" "house-prediction-rg" {
  name = "house-prediction-Project"
}

resource "azurerm_virtual_network" "house-prediction-vnet" {
  name                = "house-prediction-project-virtual-net"
  location            = data.azurerm_resource_group.house-prediction-rg.location
  resource_group_name = data.azurerm_resource_group.house-prediction-rg.name
  address_space       = ["192.168.1.0/24"]
}

resource "azurerm_subnet" "house-prediction-sub1" {
  name                 = "house-prediction-project-subnet"
  resource_group_name  = data.azurerm_resource_group.house-prediction-rg.name
  virtual_network_name = azurerm_virtual_network.house-prediction-vnet.name
  #This subnet will containe 32 addresses among which Azure reserved 5 address for itself.
  address_prefixes = ["192.168.1.0/27"]
}

resource "azurerm_network_security_group" "house-prediction-nsg" {
  name                = "house-prediction-project-nsg"
  location            = "Central India"
  resource_group_name = data.azurerm_resource_group.house-prediction-rg.name
}

resource "azurerm_network_security_rule" "allow_ssh" {
  name                        = "allow_ssh"
  priority                    = 100
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "22"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = data.azurerm_resource_group.house-prediction-rg.name
  network_security_group_name = azurerm_network_security_group.house-prediction-nsg.name
}

resource "azurerm_network_security_rule" "allow_port_80" {
  name                        = "allow_port_80"
  priority                    = 200
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "80"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = data.azurerm_resource_group.house-prediction-rg.name
  network_security_group_name = azurerm_network_security_group.house-prediction-nsg.name
}

resource "azurerm_network_interface" "house-prediction-nic" {
  name                = "house-prediction-project-nic"
  location            = data.azurerm_resource_group.house-prediction-rg.location
  resource_group_name = data.azurerm_resource_group.house-prediction-rg.name

  ip_configuration {
    name                          = "house-prediction-project-ipconfig"
    subnet_id                     = azurerm_subnet.house-prediction-sub1.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.house-prediction-pubip.id
  }
}

resource "azurerm_public_ip" "house-prediction-pubip" {
  name                = "house-prediction-project-public-ip"
  location            = data.azurerm_resource_group.house-prediction-rg.location
  resource_group_name = data.azurerm_resource_group.house-prediction-rg.name
  allocation_method   = "Dynamic"
}

resource "azurerm_linux_virtual_machine" "house-prediction-vm-one" {
  name                            = "house-prediction-project-vm-one"
  location                        = data.azurerm_resource_group.house-prediction-rg.location
  resource_group_name             = data.azurerm_resource_group.house-prediction-rg.name
  size                            = var.server_size
  admin_username                  = var.server_username
  disable_password_authentication = true
  network_interface_ids           = [azurerm_network_interface.house-prediction-nic.id]

  admin_ssh_key {
    username   = var.server_username
    public_key = file("~/.ssh/id_rsa.pub")
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Premium_LRS"
    disk_size_gb         = 64

  }


  source_image_reference {
    publisher = "canonical"
    offer     = "0001-com-ubuntu-server-focal"
    sku       = "20_04-lts-gen2"
    version   = "latest"
  }

  # This option is used to storevms booting data inside Azure storage account. Using Azure Portal too this options is recommended by Azure.
  boot_diagnostics {
    enabled = true
  }

  tags = {
    environment = "dev"
  }

}
