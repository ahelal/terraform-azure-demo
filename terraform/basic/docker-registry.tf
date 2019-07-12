resource "azurerm_container_registry" "acr" {
  name                = "${format("rg%s%s", "kv", random_id.server.hex)}"
  location            = "${azurerm_resource_group.main.location}"
  resource_group_name = "${azurerm_resource_group.main.name}"
  sku                 = "Basic"
  admin_enabled       = true
  tags = {
    environment = "${var.environment}"
  }
}


output "username" {
  value = "${azurerm_container_registry.acr.admin_username}"
}

output "password" {
  value = "${azurerm_container_registry.acr.admin_password}"
}

output "login_server" {
  value = "${azurerm_container_registry.acr.login_server}"
}
