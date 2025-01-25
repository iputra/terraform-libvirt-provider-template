# outputs.tf

output "vm_ips" {
  description = "The IP addresses of the VMs"
  value       = { for k, v in module.vms : k => v.vm_ip }
}

output "vm_names" {
  description = "The names of the VMs"
  value       = { for k, v in module.vms : k => v.vm_name }
}
