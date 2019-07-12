provider "azurerm" {
}

resource "azurerm_resource_group" "main" {
  name     = "${var.resourceGroup}"
  location = "${var.location}"

  tags = {
       environment = "${var.environment}"
  }
}
resource "azurerm_virtual_network" "main" {
  name                = "${var.environment}-network"
  address_space       = ["192.168.0.0/24"]
  location            = "${azurerm_resource_group.main.location}"
  resource_group_name = "${azurerm_resource_group.main.name}"
}

resource "azurerm_subnet" "subneta" {
  name                 = "subneta"
  resource_group_name  = "${azurerm_resource_group.main.name}"
  virtual_network_name = "${azurerm_virtual_network.main.name}"
  address_prefix       = "192.168.0.0/26"

}
resource "azurerm_subnet" "subnetb" {
  name                 = "subnetb"
  resource_group_name  = "${azurerm_resource_group.main.name}"
  virtual_network_name = "${azurerm_virtual_network.main.name}"
  address_prefix       = "192.168.0.64/26"
}

resource "azurerm_subnet" "subnetagpgw" {
  name                 = "subnetappgw"
  resource_group_name  = "${azurerm_resource_group.main.name}"
  virtual_network_name = "${azurerm_virtual_network.main.name}"
  address_prefix       = "192.168.0.128/26"
}