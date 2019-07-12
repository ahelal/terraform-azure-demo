

variable "appgw_name" {
  default = "main-appgateway"
}
variable "backend_pool" {
  default = "test-network-app-a"
}

variable "networkResourceGroup" {
  default = "testResourceGroup2"
}
variable "location" {
  default = "westeurope"
}
variable "environment" {
  default = "test"
}
variable "user" {
  default = "ubuntu"
}

variable "vmss_name" {
  default = "vmss"
}

variable "pass" {
}
variable "principal_name" {

}

variable "vm_size" {
  default = "Standard_DS1_v2"
}

variable "custom_data" {
  default = ""
}

variable "automatic_os_upgrade" {
  default = false
}
variable "upgrade_policy_mode" {
  default = "Manual"
}

variable "instance_count" {
  default = "1"
}

variable "key_vault_name" {
}

variable "docker_pass" {
  default = ""
}
variable "env" {
  
}

