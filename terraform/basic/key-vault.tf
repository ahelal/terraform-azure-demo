data "azurerm_client_config" "current" {}

resource "random_id" "server" {
  keepers = {
    ami_id = 1
  }

  byte_length = 8
}
resource "azurerm_key_vault" "main" {
  name                = "${format("%s%s", "kv", random_id.server.hex)}"
  location            = "${azurerm_resource_group.main.location}"
  resource_group_name = "${azurerm_resource_group.main.name}"
  tenant_id           = "${data.azurerm_client_config.current.tenant_id}"

  sku_name = "premium"

  access_policy {
    tenant_id = "${data.azurerm_client_config.current.tenant_id}"
    object_id = "${data.azuread_user.test_user.id }"

    key_permissions = [
      "create",
      "get",
      "List"
    ]

    secret_permissions = [
      "set",
      "get",
      "delete",
      "List",
    ]
  }

  tags = {
    environment = "${var.environment}"
  }
}


resource "azurerm_key_vault_secret" "secureinfo" {
  name         = "SECUREINFO"
  value        = "SUPER SECURE PASSWORD"
  key_vault_id = "${azurerm_key_vault.main.id}"

  tags = {
    environment = "${var.environment}"
  }
}