resource "azurerm_resource_group" "main" {
  name     = "${var.vmss_name}-rg"
  location = "${var.location}"

  tags = {
    environment = "${var.environment}"
  }
}

resource "azurerm_virtual_machine_scale_set" "main" {
  name                = "${var.vmss_name}-vm"
  location            = "${azurerm_resource_group.main.location}"
  resource_group_name = "${azurerm_resource_group.main.name}"

  # automatic rolling upgrade
  automatic_os_upgrade = "${var.automatic_os_upgrade}"
  upgrade_policy_mode  = "${var.upgrade_policy_mode}"

  sku {
    name     = "Standard_F2"
    tier     = "Standard"
    capacity = "${var.instance_count}"
  }

  identity {
    type = "SystemAssigned"
  }
  storage_profile_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }

  storage_profile_os_disk {
    name              = ""
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }

  os_profile {
    admin_username = "${var.user}"
    admin_password = "${var.pass}"
    custom_data    = "${var.custom_data}"
    computer_name_prefix = "${var.vmss_name}"
  }
  os_profile_linux_config {
    disable_password_authentication = false
  }

  network_profile {
    name    = "terraformnetworkprofile"
    primary = true

    ip_configuration {
      name      = "TestIPConfiguration"
      primary   = true
      subnet_id = "${data.azurerm_subnet.subneta.id}"
      application_gateway_backend_address_pool_ids =  [ "${data.azurerm_resource_group.main.id}/providers/Microsoft.Network/applicationGateways/${var.appgw_name}/backendAddressPools/${var.backend_pool}"]
      # load_balancer_inbound_nat_rules_ids    = ["${element(azurerm_lb_nat_pool.lbnatpool.*.id, count.index)}"]
    }
  }

  tags = {
    environment = "staging"
  }
}

