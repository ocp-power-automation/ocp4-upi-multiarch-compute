################################################################
# Copyright 2025 - IBM Corporation. All rights reserved
# SPDX-License-Identifier: Apache-2.0
################################################################

provider "openstack" {
  user_name   = var.user_name
  password    = var.password
  tenant_name = var.tenant_name
  domain_name = var.domain_name
  auth_url    = var.auth_url
  insecure    = var.insecure
}

locals {
  bindings = []
}

data "openstack_networking_network_v2" "network" {
  name = var.network_name
}

data "openstack_networking_subnet_v2" "subnet" {
  network_id = data.openstack_networking_network_v2.network.id
}

resource "openstack_networking_port_v2" "worker_port" {
  count          = var.worker_count
  name           = "${var.power_worker_prefix}-port-${count.index}"
  network_id     = data.openstack_networking_network_v2.network.id
  admin_state_up = "true"
  fixed_ip {
    subnet_id  = data.openstack_networking_subnet_v2.subnet.id
    ip_address = ""
  }
  dynamic "binding" {
    for_each = local.bindings
    content {
      vnic_type = binding.value["vnic_type"]
      profile   = binding.value["profile"]
    }
  }
}

locals {
  ids = openstack_networking_port_v2.worker_port.*.id
}

# Create a blank volume for each worker
resource "openstack_blockstorage_volume_v3" "worker_volume" {
  count       = var.worker_count
  name        = "${var.power_worker_prefix}-volume-${count.index}"
  size        = var.volume_size
  volume_type = var.volume_type
}

resource "openstack_compute_instance_v2" "worker" {
  count             = var.worker_count
  name              = "${var.power_worker_prefix}-${count.index}"
  flavor_id         = var.flavor_id
  availability_zone = var.openstack_availability_zone

  # Instead of using image_id and ignition, we'll use a blank volume
  block_device {
    uuid                  = openstack_blockstorage_volume_v3.worker_volume[count.index].id
    source_type           = "volume"
    boot_index            = 0
    destination_type      = "volume"
    delete_on_termination = true
  }

  network {
    port = local.ids[count.index]
  }

  power_state = "shutoff"

  # No config_drive needed since we're not using ignition
}