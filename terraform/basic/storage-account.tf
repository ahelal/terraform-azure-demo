resource "azurerm_storage_account" "main" {
  name                     = "${format("sa%s%s", "kv", random_id.server.hex)}"
  location                 = "${azurerm_resource_group.main.location}"
  resource_group_name      = "${azurerm_resource_group.main.name}"
  account_tier             = "Standard"
  account_kind             = "StorageV2"
  account_replication_type = "LRS"
  tags = {
    environment = "${var.environment}"
  }

  provisioner "local-exec" {
    command = "az storage blob service-properties update --account-name ${azurerm_storage_account.main.name} --static-website  --index-document index.html --404-document 404.html"
  }
}
