resource "azurerm_postgresql_server" "example_ssl_enforcement_enabled" {
    name                                = "example-psqlserver"
    location                            = azurerm_resource_group.example.location
    resource_group_name                 = azurerm_resource_group.example.name
    administrator_login                 = "psqladminun"
    administrator_login_password        = "H@Sh1CoR3!"
    sku_name                            = "GP_Gen5_4"
    storage_mb                          = 640000
    version                             = "9.6"
    ssl_enforcement_enabled             = false
    geo_redundant_backup_enabled = true
}


resource azurerm_network_security_group "positive3" {
  location            = "East US"
  name                = "nsg"
  resource_group_name = "testrg2"

  security_rule {
    access                     = "Allow"
    direction                  = "Inbound"
    name                       = "AllowSSH"
    priority                   = 200
    protocol                   = "TCP"
    source_address_prefix      = "*"
    source_port_range          = "*"
    destination_port_range     = "22-22"
    destination_address_prefix = "*"
  }

  security_rule {
    access                     = "Allow"
    direction                  = "Inbound"
    name                       = "AllowRDP"
    priority                   = 300
    protocol                   = "TCP"
    source_address_prefix      = "*"
    source_port_range          = "*"
    destination_port_range     = "21, 22-23,2250"
    destination_address_prefix = "*"
  }
}


resource azurerm_network_security_group "positive2" {
  location            = "East US"
  name                = "nsg"
  resource_group_name = "testrg2"

  security_rule {
    access                     = "Allow"
    direction                  = "Inbound"
    name                       = "AllowRDP"
    priority                   = 200
    protocol                   = "TCP"
    source_address_prefix      = "*"
    source_port_range          = "*"
    destination_port_range     = "3389-3390"
    destination_address_prefix = "*"
  }

  security_rule {
    access                     = "Allow"
    direction                  = "Inbound"
    name                       = "AllowRDP"
    priority                   = 300
    protocol                   = "TCP"
    source_address_prefix      = "*"
    source_port_range          = "*"
    destination_port_range     = "2000-4430"
    destination_address_prefix = "*"
  }
}


resource "google_container_cluster" "primary" {
  name     = "my-gke-cluster"
  location = "us-central1"
  remove_default_node_pool = true
  initial_node_count       = 1
}

resource "azurerm_virtual_machine" "positive1" {
  name                  = "negative1"
  location              = "us-east-1"
  resource_group_name   = "blabla"
  network_interface_ids = [""]
  vm_size               = "Standard_DS1_v2"

  storage_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "16.04-LTS"
    version   = "latest"
  }

  storage_os_disk {
    name              = "jumpbox-osdisk"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }

  os_profile {
    computer_name  = "jumpbox"
    admin_username = "${var.admin_username}"
    admin_password = "${var.admin_password}"
  }

  os_profile_linux_config {
    disable_password_authentication = false
  }

  tags {
    environment = "codelab"
  }
}