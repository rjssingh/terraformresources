//module "KeyVault" {
//  source = "./modules/Key_Vault/resources.tf"
//}

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



//adding key_vault information//

data "azurerm_key_vault" "example" {
  name                = "rjskyraterraform"
  resource_group_name = var.resourcegroupname
}

data "azurerm_key_vault_secret" "example" {
  name         = "VMpassword"
  key_vault_id = data.azurerm_key_vault.example.id
}

//VM no 2///

resource "azurerm_virtual_network" "example3" {
  name                = "example-network3"
  address_space       = ["10.0.0.0/16"]
  location            = var.region
  resource_group_name = var.resourcegroupname
}

resource "azurerm_subnet" "example3" {
  name                 = "internal3"
  resource_group_name  = var.resourcegroupname
  virtual_network_name = azurerm_virtual_network.example3.name
  address_prefixes     = ["10.0.2.0/24"]
}

resource "azurerm_public_ip" "example3" {
  name                = "acceptanceTestPublicIp13"
  resource_group_name = var.resourcegroupname
  location            = var.region
  allocation_method   = "Static"
}

resource "azurerm_network_interface" "example3" {
  name                = "example-nic2"
  location            = var.region
  resource_group_name = var.resourcegroupname

  ip_configuration {
    name                          = "internal3"
    subnet_id                     = azurerm_subnet.example3.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id = azurerm_public_ip.example3.id
  }
}

resource "azurerm_windows_virtual_machine" "example3" {
  name                = "example-machin3"
  resource_group_name = var.resourcegroupname
  location            = var.region
  size                = "Standard_F2"
  admin_username      = "adminuser"
  admin_password      = data.azurerm_key_vault_secret.example.value
  network_interface_ids = [
    azurerm_network_interface.example3.id,
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