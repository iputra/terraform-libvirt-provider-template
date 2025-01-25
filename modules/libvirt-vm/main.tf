# modules/libvirt-vm/main.tf

terraform {
  required_version = ">= 0.13"
  required_providers {
    libvirt = {
      source  = "dmacvicar/libvirt"
      version = "~> 0.7.0"
    }
  }
}

resource "libvirt_volume" "vm_volume" {
  name           = "${var.vm_name}-volume"
  base_volume_id = var.base_volume_id
  pool           = var.pool_name
  size           = var.disk_size
}

resource "libvirt_volume" "additional_disks" {
  count  = length(var.additional_disks)
  name   = "${var.vm_name}-${var.additional_disks[count.index].name}"
  pool   = var.pool_name
  size   = var.additional_disks[count.index].size
  format = "qcow2"
}

resource "libvirt_cloudinit_disk" "cloudinit" {
  name           = "${var.vm_name}-cloudinit.iso"
  user_data      = data.template_file.user_data.rendered
  network_config = data.template_file.network_config.rendered
  pool           = var.pool_name
}

data "template_file" "user_data" {
  template = file("${path.module}/cloud_init.cfg")
  vars = {
    hostname = var.vm_name
    ssh_key  = var.ssh_public_key
  }
}

data "template_file" "network_config" {
  template = file("${path.module}/network_config.cfg")
  vars = {
    vm_ip        = var.vm_ip
    network_cidr = var.network_cidr
  }
}

resource "libvirt_domain" "vm_domain" {
  name   = var.vm_name
  memory = var.memory
  vcpu   = var.vcpu

  cloudinit = libvirt_cloudinit_disk.cloudinit.id

  network_interface {
    network_id     = var.network_id
    addresses      = [var.vm_ip]
    wait_for_lease = false
  }

  disk {
    volume_id = libvirt_volume.vm_volume.id
  }

  dynamic "disk" {
    for_each = libvirt_volume.additional_disks
    content {
      volume_id = disk.value.id
    }
  }


  console {
    type        = "pty"
    target_type = "serial"
    target_port = "0"
  }

  graphics {
    type        = "spice"
    listen_type = "address"
    autoport    = true
  }
}
