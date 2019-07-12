module "myappa-vm" {
  source = "../modules/vm"
  environment = "test"
  host="bastion"
  user = "ubuntu"
  pass = "${var.pass}"
  custom_data = ""
}
