################################################################
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Licensed Materials - Property of IBM
#
# ©Copyright IBM Corp. 2025
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
################################################################

resource "random_id" "label" {
  byte_length = "2"
}

resource "openstack_compute_keypair_v2" "key-pair" {
  name       = "${var.power_worker_prefix}-${random_id.label.hex}"
  public_key = sensitive(file(var.public_key_file))
}

data "openstack_compute_flavor_v2" "helper" {
  name = var.helper["instance_type"]
}

resource "openstack_networking_port_v2" "helper_port" {
  name           = "${var.power_worker_prefix}-port-helper"
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

resource "openstack_compute_instance_v2" "helper" {
  name      = "${var.power_worker_prefix}-helper"
  image_id  = var.helper["image_id"]
  flavor_id = data.openstack_compute_flavor_v2.helper.id
  key_pair  = openstack_compute_keypair_v2.key-pair.name
  network {
    port = openstack_networking_port_v2.helper_port.id
  }
  availability_zone = var.openstack_availability_zone
}

locals {
  dnsmasq_details = {
    resolver_ip = "${var.resolver_ip}"
    details = [for helper in openstack_networking_port_v2.worker_port :
      {
        mac_address = helper.mac_address
        ip_address  = helper.all_fixed_ips[0]
      }
    ]
  }

  helper_details = {
    details = [for helper in openstack_networking_port_v2.worker_port :
      {
        mac_address = helper.mac_address
        ip_address  = helper.all_fixed_ips[0]
      }
    ]
  }
}

resource "null_resource" "setup_helper" {
  count      = 1
  depends_on = [openstack_compute_instance_v2.helper]

  connection {
    type        = "ssh"
    user        = var.rhel_username
    host        = openstack_networking_port_v2.helper_port.all_fixed_ips[0]
    private_key = sensitive(file(var.private_key_file))
    agent       = var.ssh_agent
    timeout     = "${var.connection_timeout}m"
  }

  # Populate `dnsmasq` configuration
  provisioner "file" {
    content     = templatefile("${path.module}/templates/dnsmasq.conf.tftpl", local.dnsmasq_details)
    destination = "/etc/dnsmasq.conf"
  }

  provisioner "file" {
    content     = file("${path.module}/files/setup.sh")
    destination = "/root/setup.sh"
  }

  # dev-note: turning off tx-checksum we're not setting mtu
  # just in case - `ip link set $${IFNAME} mtu 9000`
  provisioner "remote-exec" {
    inline = [<<EOF
chmod +x setup.sh
bash setup.sh "${var.ignition_ip}"
EOF
    ]
  }

  provisioner "file" {
    content     = file("${path.module}/files/httpd.conf")
    destination = "/etc/httpd/conf/httpd.conf"
  }

  provisioner "file" {
    content     = file("${path.module}/files/restart.conf")
    destination = "/etc/systemd/system/httpd.service.d/restart.conf"
  }

  # prb112: default route skips dnsmasq and uses the network gateway directly.
  provisioner "remote-exec" {
    inline = [<<EOF
    echo "" >> /etc/dnsmasq.conf
echo dhcp-option=option:router,$(nmcli -g ip4.gateway connection show 'System eth0') >> /etc/dnsmasq.conf
systemctl restart dnsmasq
EOF
    ]
  }
}
