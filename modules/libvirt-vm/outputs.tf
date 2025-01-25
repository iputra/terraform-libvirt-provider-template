# modules/libvirt-vm/outputs.tf

output "vm_ip" {
  description = "The IP address of the VM"
  value       = libvirt_domain.vm_domain.network_interface[0].addresses[0]
}

output "vm_name" {
  description = "The name of the VM"
  value       = libvirt_domain.vm_domain.name
}
