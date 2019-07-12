data "template_file" "init" {
  template = "${file("${path.module}/cloudinit.tpl")}"
  vars = {
    key_vault_name   = "${var.key_vault_name}"
    docker_registery = "${var.DOCKER_REG}"
    docker_image_uri = "${var.DOCKER_REG}/myapp:0.1.1"
    docker_user      = "${var.DOCKER_USER}"
    docker_pass      = "${var.DOCKER_PASS}"
  }
}

module "myappa-vm" {
  source         = "../modules/vmss"
  environment    = "test"
  vmss_name      = "myapp-a"
  user           = "ubuntu"
  pass           = "${var.pass}"
  principal_name = "${var.principal_name}"
  key_vault_name = "${var.key_vault_name}"
  backend_pool   = "test-network-app-a"
  custom_data    = "${data.template_file.init.rendered}"
}
