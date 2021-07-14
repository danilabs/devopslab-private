# Tamaño de la VM de master
variable "vm_size_master" {
  type        = string
  description = "Tamaño de la maquina virtual master"
  default     = "Standard_B2s" # 2 CPUs y 4.0 GB RAM
}

variable "vm_size_worker" {
  type        = string
  description = "Tamaño de la maquina virtual worker"
  default     = "Standard_D1_v2" # 1 CPU y 3.5 GB RAM
}

# Lista de workers a crear
variable "vm_workers" {
  description = "Workers"
  type        = list(string)
  default     = ["worker1.localhostunir.local", "worker2.localhostunir.local"]
}

# Lista de master a crear
variable "vm_master" {
  description = "Master"
  type        = list(string)
  default     = ["master.localhostunir.local"]
}
