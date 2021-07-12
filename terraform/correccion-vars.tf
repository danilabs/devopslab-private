# Region de azure
variable "location" {
  type = string
  description = "Region de Azure donde crearemos la infraestructura"
  default = "West Europe"
}

# Cuenta donde alojar los datos
variable "storage_account" {
  type = string
  description = "Nombre para la storage account"
  default = "storageddiezunir"
}

# Clave SSH
variable "public_key_path" {
  type = string
  description = "Ruta para la clave pública de acceso a las instancias"
  default = "~/.ssh/id_rsa.pub" # o la ruta correspondiente
}

# Usuario SSH
variable "ssh_user" {
  type = string
  description = "Usuario para hacer ssh"
  #default = "adminUsername"
  default = "ddiez"
}
