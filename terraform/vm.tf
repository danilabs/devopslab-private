# Creamos maquina virtual master
# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/linux_virtual_machine

resource "azurerm_linux_virtual_machine" "vm_master" {
  name                            = var.vm_master[count.index]
  resource_group_name             = azurerm_resource_group.rg.name
  location                        = azurerm_resource_group.rg.location
  size                            = var.vm_size_master
  admin_username                  = var.ssh_user
  count                           = length(var.vm_master)
  network_interface_ids           = [azurerm_network_interface.myNicMaster[count.index].id]
  disable_password_authentication = true
  computer_name                   = var.vm_master[count.index]

  admin_ssh_key {
    username   = var.ssh_user
    public_key = file(var.public_key_path)
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  plan {
    name      = "centos-8-stream-free"
    product   = "centos-8-stream-free"
    publisher = "cognosys"
  }

  source_image_reference {
    publisher = "cognosys"
    offer     = "centos-8-stream-free"
    sku       = "centos-8-stream-free"
    version   = "1.2019.0810"
  }

  boot_diagnostics {
    storage_account_uri = azurerm_storage_account.stAccount.primary_blob_endpoint
  }

  tags = {
    environment = "CP2"
  }

}

resource "azurerm_linux_virtual_machine" "vm_worker" {
  name                            = var.vm_workers[count.index]
  resource_group_name             = azurerm_resource_group.rg.name
  location                        = azurerm_resource_group.rg.location
  size                            = var.vm_size_worker
  admin_username                  = var.ssh_user
  network_interface_ids           = [azurerm_network_interface.myNicWorkers[count.index].id]
  count                           = length(var.vm_workers)
  disable_password_authentication = true
  computer_name                   = var.vm_workers[count.index]

  admin_ssh_key {
    username   = var.ssh_user
    public_key = file(var.public_key_path)
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  plan {
    name      = "centos-8-stream-free"
    product   = "centos-8-stream-free"
    publisher = "cognosys"
  }

  source_image_reference {
    publisher = "cognosys"
    offer     = "centos-8-stream-free"
    sku       = "centos-8-stream-free"
    version   = "1.2019.0810"
  }

  boot_diagnostics {
    storage_account_uri = azurerm_storage_account.stAccount.primary_blob_endpoint
  }

  tags = {
    environment = "CP2"
  }

}
