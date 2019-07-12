data "azurerm_subnet" "subneta" {
  name                 = "subneta"
  virtual_network_name = "${var.environment}-network"
  resource_group_name  = "${var.networkResourceGroup}"
}
