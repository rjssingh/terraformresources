resource "azurerm_virtual_network" "example" {
  name                = "example-network"
  address_space       = ["10.0.0.0/16"]
  location            = var.region
  resource_group_name = var.resourcegroupname
}

resource "azurerm_subnet" "example" {
  name                 = "internal"
  resource_group_name  = var.resourcegroupname
  virtual_network_name = azurerm_virtual_network.example.name
  address_prefixes     = ["10.0.2.0/24"]
}

resource "azurerm_public_ip" "example" {
  name                = "acceptanceTestPublicIp1"
  resource_group_name = var.resourcegroupname
  location            = var.region
  allocation_method   = "Static"
}

resource "azurerm_network_interface" "example" {
  name                = "example-nic"
  location            = var.region
  resource_group_name = var.resourcegroupname

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.example.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id = azurerm_public_ip.example.id
  }
}

resource "azurerm_windows_virtual_machine" "example" {
  name                = "example-machine"
  resource_group_name = var.resourcegroupname
  location            = var.region
  size                = "Standard_F2"
  admin_username      = "adminuser"
  admin_password      = "P@$$w0rd1234!"
  network_interface_ids = [
    azurerm_network_interface.example.id,
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2016-Datacenter"
    version   = "latest"
  }
}


//VM no 2///

resource "azurerm_virtual_network" "example2" {
  name                = "example-network2"
  address_space       = ["10.0.0.0/16"]
  location            = var.region
  resource_group_name = var.resourcegroupname
}

resource "azurerm_subnet" "example2" {
  name                 = "internal2"
  resource_group_name  = var.resourcegroupname
  virtual_network_name = azurerm_virtual_network.example2.name
  address_prefixes     = ["10.0.2.0/24"]
}

resource "azurerm_public_ip" "example2" {
  name                = "acceptanceTestPublicIp12"
  resource_group_name = var.resourcegroupname
  location            = var.region
  allocation_method   = "Static"
}

resource "azurerm_network_interface" "example2" {
  name                = "example-nic2"
  location            = var.region
  resource_group_name = var.resourcegroupname

  ip_configuration {
    name                          = "internal2"
    subnet_id                     = azurerm_subnet.example2.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id = azurerm_public_ip.example2.id
  }
}

resource "azurerm_windows_virtual_machine" "example2" {
  name                = "example-machine2"
  resource_group_name = var.resourcegroupname
  location            = var.region
  size                = "Standard_F2"
  admin_username      = "adminuser"
  admin_password      = "P@$$w0rd1234!"
  network_interface_ids = [
    azurerm_network_interface.example2.id,
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2016-Datacenter"
    version   = "latest"
  }
}