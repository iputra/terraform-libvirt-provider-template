# main.tf

terraform {
  required_version = ">= 0.13"
  required_providers {
    libvirt = {
      source  = "dmacvicar/libvirt"
      version = "~> 0.7.0"
    }
  }
}

provider "libvirt" {
  uri = var.libvirt_uri
}

resource "libvirt_pool" "vm_pool" {
  name = var.pool_name
  type = "dir"
  path = var.pool_path
}

resource "libvirt_volume" "base_volume" {
  name   = "${var.project_name}-base"
  pool   = libvirt_pool.vm_pool.name
  source = var.base_image_path
  format = "qcow2"
}

resource "libvirt_network" "vm_network" {
  name      = "${var.project_name}-network"
  mode      = "nat"
  domain    = var.network_domain
  addresses = [var.network_cidr]
}

module "vms" {
  source   = "./modules/libvirt-vm"
  for_each = var.vms

  vm_name        = each.key
  base_volume_id = libvirt_volume.base_volume.id
  pool_name      = libvirt_pool.vm_pool.name
  disk_size      = each.value.disk_size
  network_id     = libvirt_network.vm_network.id
  vm_ip          = each.value.ip
  network_cidr   = var.network_cidr
  ssh_public_key = file(var.ssh_public_key_path)
  memory         = each.value.memory
  vcpu           = each.value.vcpu
  additional_disks = each.value.additional_disks
}
