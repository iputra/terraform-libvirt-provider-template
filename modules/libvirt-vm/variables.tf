# modules/libvirt-vm/variables.tf

variable "vm_name" {
  description = "The name of the VM"
  type        = string
}

variable "base_volume_id" {
  description = "The ID of the base volume"
  type        = string
}

variable "pool_name" {
  description = "The name of the storage pool"
  type        = string
}

variable "disk_size" {
  description = "The size of the VM's disk in bytes"
  type        = number
}

variable "network_id" {
  description = "The ID of the network to connect the VM to"
  type        = string
}

variable "vm_ip" {
  description = "The IP address for the VM"
  type        = string
}

variable "network_cidr" {
  description = "The CIDR for the VM network"
  type        = string
}

variable "ssh_public_key" {
  description = "The public SSH key"
  type        = string
}

variable "memory" {
  description = "The amount of memory for the VM in MB"
  type        = number
}

variable "vcpu" {
  description = "The number of vCPUs for the VM"
  type        = number
}

variable "additional_disks" {
  description = "List of additional disks to attach to the VM"
  type = list(object({
    name = string
    size = number
  }))
  default = []  # This makes it optional
}
