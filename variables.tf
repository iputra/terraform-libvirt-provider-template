# variables.tf

variable "libvirt_uri" {
  description = "The URI of the libvirt host"
  default     = "qemu:///system"
}

variable "project_name" {
  description = "The name of the project"
  type        = string
}

variable "pool_name" {
  description = "The name of the storage pool"
  default     = "default"
}

variable "pool_path" {
  description = "The path of the storage pool"
  default     = "/data/terraform/volume"
}

variable "base_image_path" {
  description = "The path to the base image"
  default     = "/data/terraform/images/noble-server-cloudimg-amd64.img"
}

variable "network_domain" {
  description = "The domain for the VM network"
  default     = "vm.local"
}

variable "network_cidr" {
  description = "The CIDR for the VM network"
  default     = "10.0.1.0/24"
}

variable "ssh_public_key_path" {
  description = "The path to the public SSH key"
  default     = "~/.ssh/id_rsa.pub"
}

variable "vms" {
  description = "Map of VMs to create"
  type = map(object({
    ip        = string
    disk_size = number
    memory    = number
    vcpu      = number
    additional_disks = optional(list(object({
      name = string
      size = number
    })), [])
  }))
}
