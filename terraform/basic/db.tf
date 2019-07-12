resource "random_id" "dbpassword" {
  keepers = {
    ami_id = 1
  }

  byte_length = 12
}

resource "azurerm_mariadb_server" "main" {
  name                =   "${format("maridb%s%s", "kv", random_id.server.hex)}"
  location            = "${azurerm_resource_group.main.location}"
  resource_group_name = "${azurerm_resource_group.main.name}"

  sku {
    name     = "B_Gen5_2"
    capacity = 2
    tier     = "Basic"
    family   = "Gen5"
  }

  storage_profile {
    storage_mb            = 51200
    backup_retention_days = 7
    geo_redundant_backup  = "Disabled"
  }

  administrator_login          = "mariauser"
  administrator_login_password = "${format("%s$", random_id.dbpassword.hex)}"
  version                      = "10.2"
  ssl_enforcement              = "Enabled"
}

resource "azurerm_mariadb_database" "main" {
  name                = "mariadb_database"
  resource_group_name = "${azurerm_resource_group.main.name}"
  server_name         = "${azurerm_mariadb_server.main.name}"
  charset             = "utf8"
  collation           = "utf8_general_ci"
}

output "dbp_pass" {
  value = "${format("%s$", random_id.dbpassword.hex)}"
}


resource "azurerm_key_vault_secret" "dbpass" {
  name         = "DBPASS"
  value        = "${format("%s$", random_id.dbpassword.hex)}"
  key_vault_id = "${azurerm_key_vault.main.id}"

  tags = {
    environment = "${var.environment}"
  }
}

resource "azurerm_mariadb_firewall_rule" "main" {
  name                = "vnet-rule"
  resource_group_name = "${azurerm_resource_group.main.name}"
  server_name         = "${azurerm_mariadb_server.main.name}"
  start_ip_address    = "0.0.0.0"
  end_ip_address      = "0.0.0.0"
}