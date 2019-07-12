

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

variable "host" {
  default = "dockerhost"
}

variable "pass" {
}

variable "vm_size" {
  default = "Standard_DS1_v2"
}

variable "custom_data" {
  default = "hostname"
}
