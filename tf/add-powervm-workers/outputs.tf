################################################################
# Copyright 2024 - IBM Corporation. All rights reserved
# SPDX-License-Identifier: Apache-2.0
################################################################

output "add_these_to_dhcp" {
  value = "Add these values to your dhcpd.conf and update the worker-p number:\n"
}

output "multi_arch_compute_ip_combo" {
  value = [for index, s in openstack_networking_port_v2.worker_port : "host ${var.power_worker_prefix}-${index} { hardware ethernet ${s.mac_address}; fixed-address ${s.fixed_ip[0].ip_address}; }"]
}

output "add_these_to_chrony_allow" {
  description = "Add these values to your chrony.conf"
  value       = "Add an allow rule for your Power worker subnet"
}

output "add_these_named_conf_and_restart" {
  value = "Be sure your resolve_ip referenced named/resolve_ip is correctly forwarded look at /etc/named.conf in your dhcp server"
}