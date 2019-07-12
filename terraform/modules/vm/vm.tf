resource "azurerm_resource_group" "main" {
  name     = "${var.host}-rg"
  location = "${var.location}"
  tags = {
       environment = "${var.environment}"
  }
}

resource "azurerm_public_ip" "main" {
  name                         = "${var.host}-pip"
  location                     = "${azurerm_resource_group.main.location}"
  resource_group_name          = "${azurerm_resource_group.main.name}"
  public_ip_address_allocation = "Dynamic"
  idle_timeout_in_minutes      = 30
  tags = {
       environment = "${var.environment}"
  }
}
resource "azurerm_network_interface" "main" {
  name                = "${var.environment}-nic"
  location            = "${azurerm_resource_group.main.location}"
  resource_group_name = "${azurerm_resource_group.main.name}"

  ip_configuration {
    name                          = "ipconfiguration"
    subnet_id                     = "${data.azurerm_subnet.subneta.id}"
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = "${azurerm_public_ip.main.id}"
  }
}

resource "azurerm_virtual_machine" "main" {
  name                             = "${var.host}-vm"
  location                         = "${azurerm_resource_group.main.location}"
  resource_group_name              = "${azurerm_resource_group.main.name}"
  network_interface_ids            = ["${azurerm_network_interface.main.id}"]
  vm_size                          = "${var.vm_size}"
  delete_os_disk_on_termination    = true
  delete_data_disks_on_termination = true

  storage_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }
  storage_os_disk {
    name              = "${var.host}osdisk"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }

  os_profile {
    computer_name  = "${var.host}"
    admin_username = "${var.user}"
    admin_password = "${var.pass}"
    custom_data    = "${var.custom_data}"
  }
  os_profile_linux_config {
    disable_password_authentication = false
  }
  tags = {
    environment = "${var.environment}"
  }
}

output "test" {
  value = "x=${var.custom_data}"
}
