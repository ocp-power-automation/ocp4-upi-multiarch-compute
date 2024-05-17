################################################################
# Copyright 2024 - IBM Corporation. All rights reserved
# SPDX-License-Identifier: Apache-2.0
################################################################

output "add_these_to_dhcp" {
  value       = "Add these values to your dhcpd.conf and update the worker-p number \n host worker-p-0 { hardware ethernet 1:1:1:1; fixed-address 192.168.200.1; }"
}

output "mac_ip_combo" {
  value       = [for s in openstack_networking_port_v2.worker_port : "host worker-p { hardware ethernet ${s.mac_address}; fixed-address ${s.fixed_ip[0].ip_address}; }"]
}

output "add_these_to_chrony_allow" {
  description = "Add these values to your chrony.conf"
  value       = "Add an allow rule for your Power worker subnet"
}