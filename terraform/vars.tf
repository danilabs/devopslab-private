# Tamaño de la VM
variable "vm_size" {
  type = string
  description = "Tamaño de la maquina virtual"
  default = "Standard_D2_v2" # 2 CPUs y 7.0 GB RAM
}

# Lista de vm a crear
variable "vm_list" {
  description = "Maquinas virtuales"
  type = list(string)
  default = ["master","worker-1"]
}