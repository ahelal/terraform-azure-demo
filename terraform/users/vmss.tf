data "template_file" "init" {
  template = "${file("${path.module}/cloudinit.tpl")}"
  vars = {
    key_vault_name   = "${var.key_vault_name}"
    docker_registery = "${var.DOCKER_REG}"
    docker_image_uri = "${var.DOCKER_REG}/users:0.1.0"
    docker_user      = "${var.DOCKER_USER}"
    docker_pass      = "${var.DOCKER_PASS}"
    db_host          = "${var.db_host}"
    db_user          = "${var.db_user}"
    db_name          = "${var.db_name}"
  }
}

module "users-vmss" {
  source         = "../modules/vmss"
  env            = "test"
  vmss_name      = "users"
  user           = "ubuntu"
  pass           = "${var.pass}"
  principal_name = "${var.principal_name}"
  key_vault_name = "${var.key_vault_name}"
  backend_pool   = "test-network-users"
  custom_data    = "${data.template_file.init.rendered}"
}

