data "azuread_user" "test_user" {
  user_principal_name = "${var.principal_name}"
}
