data "azurerm_client_config" "current" {}

data "azurerm_subnet" "subneta" {
  name                 = "subneta"
  virtual_network_name = "${var.environment}-network"
  resource_group_name  = "${var.networkResourceGroup}"
}

data "azurerm_key_vault" "main" {
  name                = "${var.key_vault_name}"
  resource_group_name = "${var.networkResourceGroup}"
}

data "azurerm_resource_group" "main" {
  name = "appGW-RG"
}

data "azuread_user" "current_user" {
  user_principal_name = "${var.principal_name}"
}
