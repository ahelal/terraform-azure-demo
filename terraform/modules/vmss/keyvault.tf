resource "azurerm_key_vault_access_policy" "vmss_access" {
  key_vault_id = "${data.azurerm_key_vault.main.id}"
  tenant_id = "${data.azurerm_client_config.current.tenant_id}"
  object_id = "${lookup(azurerm_virtual_machine_scale_set.main.identity[0], "principal_id")}"
  key_permissions = [
      "get",
  ]
  secret_permissions = [
      "get",
      "List",
  ]
}
output "objectid" {
  value = "${lookup(azurerm_virtual_machine_scale_set.main.identity[0], "principal_id")}"
}
