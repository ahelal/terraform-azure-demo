
resource "local_file" "shell_vars" {
    content     = <<EOF
#!/bin/bash
export TF_VAR_DOCKER_PASS="${azurerm_container_registry.acr.admin_password}"
export TF_VAR_DOCKER_USER="${azurerm_container_registry.acr.admin_username}"
export TF_VAR_DOCKER_REG="${azurerm_container_registry.acr.login_server}"

export TF_VAR_key_vault_name="${format("%s%s", "kv", random_id.server.hex)}"
export TF_VAR_db_host="${azurerm_mariadb_server.main.fqdn}"
export TF_VAR_db_user="mariauser"
export TF_VAR_db_name="mariadb_database"
EOF
    filename = "${path.cwd}/../../vars/generated_vars.sh"
}
