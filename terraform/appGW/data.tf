data "azurerm_subnet" "subneta" {
  name                 = "subneta"
  virtual_network_name = "${var.environment}-network"
  resource_group_name  = "${var.networkResourceGroup}"
}

data "azurerm_subnet" "subnetagpgw" {
  name                 = "subnetappgw"
  virtual_network_name = "${var.environment}-network"
  resource_group_name  = "${var.networkResourceGroup}"
}

data "azurerm_virtual_network" "vnet" {
  name                = "${var.environment}-network"
  resource_group_name  = "${var.networkResourceGroup}"
}
