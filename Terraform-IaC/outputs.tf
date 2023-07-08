output "already-created-rg" {
  value = data.azurerm_resource_group.house-prediction-rg.name
}

output "azure_vm_one_ip" {
  value = resource.azurerm_linux_virtual_machine.house-prediction-vm-one.public_ip_addresses
}

output "server_username" {
  value = var.server_username
}